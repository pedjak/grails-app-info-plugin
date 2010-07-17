package com.burtbeckwith.grails.plugins.appinfo.hibernate

import org.springframework.util.Assert

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class FakeDocFile {

	private final String _name
	private final FakeDocFolder _folder
	private final File _file

	/**
	 * Constructor.
	 *
	 * @param name   the name of the file.
	 * @param folder  the parent folder.
	 * @throws IllegalArgumentException  if one of the parameters is null.
	 */
	FakeDocFile(String name, FakeDocFolder folder) {
		Assert.notNull(name, 'The name cannot be null')
		Assert.notNull(folder, 'The parent folder cannot be null')
		_name = name
		_folder = folder
		_file = new File(folder.file, name)
	}

	/**
	 * @return the name of the file.
	 */
	String getName() { _name }

	/**
	 * @return the DocFolder.
	 */
	FakeDocFolder getFolder() { _folder }

	/**
	 * @return the File.
	 */
	File getFile() { _file }

	/**
	 * @return a list with the folders from root.
	 */
	List<FakeDocFolder> getPathFolders() { _folder.pathFolders }

	/**
	 * Return a path-like reference to this file starting on the specified
	 * folder. The folder must be a parent folder.
	 *
	 * @param folder  the folder.
	 * @return a path-like reference string.
	 */
	private String buildRefFromFolder(FakeDocFolder folder) {

		List<FakeDocFolder> folders = getPathFolders()
		int index = folders.indexOf(folder)
		if (index == -1) {
			throw new IllegalArgumentException("The specified folder is not on this file's path: $folder")
		}

		StringBuilder result = new StringBuilder()

		int count = folders.size()
		for (index++; index < count; index++) {
			result.append(folders.get(index).name).append('/')
		}

		result.append(name)

		result.toString()
	}

	/**
	 * Return a path-like reference to the specified file.
	 *
	 * @param target  the target file.
	 * @return a path-like reference string.
	 */
	String buildRefTo(FakeDocFile target) {

		List<FakeDocFolder> tgtFileFolders = target.pathFolders

		StringBuilder ref = new StringBuilder()

		FakeDocFolder parentFolder = _folder
		while (parentFolder) {
			if (tgtFileFolders.contains(parentFolder)) {
				ref.append target.buildRefFromFolder(parentFolder)
				return ref.toString()
			}

			ref.append '../'
			parentFolder = parentFolder.parent
		}

		throw new IllegalArgumentException('No parent folder in common')
	}

	@Override
	String toString() { _name }
}
