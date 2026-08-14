Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A551351C13
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 09:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699996; cv=none; b=Z3OS5hd1D7bdcGz7ZKzV0+IKDKH6ZxTkY7CW5jGQJ67k6o97FKVJ6OTdnCDAohCL2eUCajZxht+eatAg3/hghQ6ehxw6XhtykjsCLAN0RcEFJ4HhExtrEK8+pTsz9AVzITAzyiDCc22vU5WEgj3hUOy9GTRHWvjs60vKxpzuOn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699996; c=relaxed/simple;
	bh=uvThznsaD0oSQ7UnEUlqaxSjj7O+BDeL6PnOtMWzrNI=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=f6aFgRNX76RRpm/7J1EXaTMBryzFSYhCqf2CfENc7q4EU8uyOiSahQr7iPF3pHQ20PEj9l5yC5yInTPpzBQxFPGNxYesHgy3ZQRmntcdDJeASDpIfRGEjLFEqkglelONm6jeM2ltVmteOfJCiwkmtyqVTbtIcLyJJUW+rnTwMcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aJ7ArCoD; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aJ7ArCoD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786699995; x=1818235995;
  h=message-id:subject:from:to:cc:date:
   content-transfer-encoding:mime-version;
  bh=uvThznsaD0oSQ7UnEUlqaxSjj7O+BDeL6PnOtMWzrNI=;
  b=aJ7ArCoDLGRc7SBNqnLKQsVXgupdmVBYE6MjGFFHikKA8WNOIKkZMHIZ
   Q1YlQlwzItqK6NcpgsXEEIwt3dr5EBTN2njFXWF4cbtUElprm+LahcC75
   ppaPcD8L8W1Z/4YIUPz+dBDGYw3m+MjNU1b8+v9HVpz8zd8/nZeJA2dso
   Gx1LyXfOoQc/6qgCKnxlqLFqph0WILlFS1X26J83v1KUml6N08bWMh4U+
   C/6ZQMWslhEhnTgbqP7lIFis1OnM+tIfDKcHDHJMbHd516YZmnfnNARF+
   jfSGsBeEv3oX6Tsa6liHurzlpiXv4aXk0451sy0mp3UBa8x7bTE8DxaxH
   A==;
X-CSE-ConnectionGUID: CWH8PQcUTQGp/tGUglnQCQ==
X-CSE-MsgGUID: Y+24Zw7XRg+7R4dXJg9f3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="98636319"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="98636319"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 02:33:10 -0700
X-CSE-ConnectionGUID: YM2JfACfR4GraFEvVObR6A==
X-CSE-MsgGUID: 0rxYIRQSRvCMa/csE7IyaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="261537334"
Received: from rvuia-mobl.ger.corp.intel.com (HELO [10.245.244.164]) ([10.245.244.164])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 02:33:07 -0700
Message-ID: <894f9d44eae62aee5762495b4f90f9bdd2b5585d.camel@linux.intel.com>
Subject: [RFC] dmisc cgroups controller
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Tejun Heo <tj@kernel.org>, maarten.lankhorst@linux.intel.com
Cc: intel-xe@lists.freedesktop.org, cgroups@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, pallavi.mishra@intel.com
Date: Fri, 14 Aug 2026 11:32:54 +0200
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

We (drm/xe GPU driver) have a use-case where we have a very limited
number of a particular device resource (CLOS slots) that we potentially
want to expose to unprivlieged processes for reservation / allocation.
We want to be able to restrict per cgroups the number of CLOS slots
that are available for reservation / allocation.

This is not a good fit for the misc controller since these resource
types may be added and removed similar to dmem regions. Neither is it a
good fit for the dmem controller.

Would a dmisc controller be suitable here? It would be similar to the
misc countroller but with dynamic addition and removal of resource
types similar to the dmem controller.

Any input greatly appreciated.

Thanks,
Thomas
