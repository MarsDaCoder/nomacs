/*******************************************************************************************************
 nomacs is a fast and small image viewer with the capability of synchronizing multiple instances
 
 Copyright (C) 2011-2016 Markus Diem <markus@nomacs.org>
 Copyright (C) 2011-2016 Stefan Fiel <stefan@nomacs.org>
 Copyright (C) 2011-2016 Florian Kleber <florian@nomacs.org>

 This file is part of nomacs.

 nomacs is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 nomacs is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.

 related links:
 [1] http://www.nomacs.org/
 [2] https://github.com/nomacs/
 [3] http://download.nomacs.org
 *******************************************************************************************************/

#pragma once

#pragma warning(push, 0)	// no warnings from includes
#include <QAction>
#pragma warning(pop)

#pragma warning(disable: 4251)	// TODO: remove

#ifndef DllLoaderExport
#ifdef DK_LOADER_DLL_EXPORT
#define DllLoaderExport Q_DECL_EXPORT
#elif DK_DLL_IMPORT
#define DllLoaderExport Q_DECL_IMPORT
#else
#define DllLoaderExport Q_DECL_IMPORT
#endif
#endif

// Qt defines

namespace nmc {

// nomacs defines
class DkImageContainer;

/// <summary>
/// Base class of simple image manipulators.
/// Manipulators are functions that map
/// an image to an image (e.g. grayscale).
/// If this class is extended, batch processing
/// can make use of it too.
/// </summary>
class DllLoaderExport DkBaseManipulator {

public:
	DkBaseManipulator(QAction* action = 0);

	QString name() const;
	QAction* action() const;
	QIcon icon() const;

	virtual QString errorMessage() const = 0;
	virtual QImage apply(const QImage& img) const = 0;

private:
	QAction* mAction = 0;
};

/// <summary>
/// Extended image manipulators.
/// These manipulators have settings
/// and a UI that allows users to manipulate
/// the settings.
/// </summary>
/// <seealso cref="DkBaseManipulator" />
class DllLoaderExport DkBaseManipulatorExt : public DkBaseManipulator {

public:
	DkBaseManipulatorExt(QAction* action);

	void setWidget(QWidget* widget);
	QWidget* widget() const;

	void setDirty(bool dirty);
	bool isDirty() const;

private:
	bool mDirty = false;
	QWidget* mWidget = 0;
};

// Extended --------------------------------------------------------------------
class DllLoaderExport DkTinyPlanetManipulator : public DkBaseManipulatorExt {

public:
	DkTinyPlanetManipulator(QAction* action);

	QImage apply(const QImage& img) const;
	QString errorMessage() const;

	void setSize(int size);
	int size() const;

	void setAngle(int angle);
	int angle() const;

	void setInverted(bool invert);
	bool inverted() const;

private:
	int mSize = 30;
	int mAngle = 0;
	bool mInverted = false;
};

class DllLoaderExport DkUnsharpMaskManipulator : public DkBaseManipulatorExt {

public:
	DkUnsharpMaskManipulator(QAction* action);

	QImage apply(const QImage& img) const;
	QString errorMessage() const;

	void setSigma(int sigma);
	int sigma() const;

	void setAmount(int amount);
	int amount() const;

private:
	int mSigma = 30;
	int mAmount = 15;
};

class DllLoaderExport DkManipulatorManager {

public:
	DkManipulatorManager();

	// simple manipulators
	enum ManipulatorId {
		m_grayscale = 0,
		m_auto_adjust,
		m_normalize,
		m_invert,
		m_flip_h,
		m_flip_v,

		m_end
	};

	// extended manipulators
	enum ManipulatorExtId {
		m_tiny_planet = m_end,
		m_unsharp_mask,

		m_ext_end
	};

	void createManipulators(QWidget* parent);

	QVector<QAction*> actions() const;
	
	QSharedPointer<DkBaseManipulatorExt> manipulatorExt(const ManipulatorExtId& mId) const;
	QSharedPointer<DkBaseManipulator> manipulator(const ManipulatorId& mId) const;
	QSharedPointer<DkBaseManipulator> manipulator(const QAction* action) const;

private:
	QVector<QSharedPointer<DkBaseManipulator> > mManipulators;
};
}