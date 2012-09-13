From: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH v2 2/2] fs: add missing documentation to simple_xattr
 functions
Date: Thu, 13 Sep 2012 11:02:14 -0700
Message-ID: <50521FA6.7040900@xenotime.net>
References: <20120911202809.988739953@napanee.usersys.redhat.com> <20120911202810.725043407@napanee.usersys.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xenotime.net; s=default;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Subject:CC:To:MIME-Version:From:Date:Message-ID; bh=+Sgnhc8W+ibgw5F1MV4m8beoXaudCNVBKwv7YD0qBGY=;
	b=n0cvulAKO1Hs0zqDIQFJe3ARrzGK+Vp0kEDFjfmHWNi91UtNDO+MgOzPtF9Z/Dm1vMXeMaH3H+0lJ34MhdWKqXSdTvmDblZdUnUvIxaeMI409hrhd5fAWIcUWP9tGuXs;
In-Reply-To: <20120911202810.725043407-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 09/11/2012 01:28 PM, Aristeu Rozanski wrote:


+/**
+ * simple_xattr_set: xattr SET operation for in-memory/pseudo filesystems

The format for the function name/description uses '-', not ':', as:

 * simple_xattr_set - xattr SET operation for in-memory/pseudo filesystems

+ * @xattrs: simple_xattr list
+ * @name: name of the new extended attribute
+ * @value: value of the new extended attribute. If NULL, will remove the
+ *	   attribute

Missing @size parameter description.

+ * @flags: if XATTR_CREATE is set, no already existing extended attribute may
+ *	   exist. If XATTR_REPLACE is set, the extended attribute should exist.
+ *
+ * returns -ENOMEM for allocation failures, -EEXIST in case XATTR_CREATE is
+ *	   set in flags and an extended attribute with the same name exists,
+ *	   -ENODATA if XATTR_REPLACE is set in flags but no entry with the
+ *	   specified name exists.
  */
 int simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
 		     const void *value, size_t size, int flags)



-- 
~Randy
