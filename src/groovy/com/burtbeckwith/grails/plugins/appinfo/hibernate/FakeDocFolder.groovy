package com.burtbeckwith.grails.plugins.appinfo.hibernate

import org.springframework.util.Assert

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class FakeDocFolder {

	/**
	 * The name of the folder.
	 */
	private String _name

	/**
	 * The parent folder.
	 */
	private FakeDocFolder _parent

	/**
	 * The File instance.
	 */
	private final File _file

	/**
	 * Holds a list with the folders that are between this folder and root.
	 */
	private final List<FakeDocFolder> _pathFolders = []

	/**
	 * Constructor for the root folder.
	 *
	 * @param root the File that represents the root for the documentation.
	 */
	FakeDocFolder(File root) {
		Assert.notNull root, 'Root File cannot be null'
		_file = root
		_pathFolders.add(this)
	}

	/**
	 * Constructor.
	 *
	 * @param name  the name of the file.
	 * @param parent  the parent folder.
	 */
	FakeDocFolder(String name, FakeDocFolder parent) {
		Assert.notNull name, 'Name cannot be null'
		Assert.notNull parent, 'Parent folder cannot be null'

		_name = name
		_parent = parent
		_file = new File(_parent.file, _name)

		if (_parent) {
			_pathFolders.addAll(_parent.pathFolders)
			_pathFolders.add(this)
		}
	}

	/**
	 * @return the name of this folder.
	 */
	String getName() { _name }

	/**
	 * @return the parent folder.
	 */
	FakeDocFolder getParent() { _parent }

	/**
	 * @return the File instance.
	 */
	File getFile() { _file }

	/**
	 * @return a list with the folders from root.
	 */
	List<FakeDocFolder> getPathFolders() { _pathFolders }

	@Override
	String toString() { _name }
}
