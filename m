From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Date: Wed, 18 Jan 2012 09:47:32 -0800
Message-ID: <20120118174732.GG30664@google.com>
References: <4F13DA90.2000603@cn.fujitsu.com>
 <4F13DAA9.4070703@cn.fujitsu.com>
 <20120117175322.GC6762@google.com>
 <4F168266.3060205@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Lqdy1mLODXmo16QVScdb1HR3AV+B/OlkIA5mPH9hh1k=;
        b=cA5Yq2g6A8bwFp06sktYwgdj5sDGbwb+qCdbotHiFqJAMXy9sN9/jZ1yFI0U/PiYmc
         zb2ayyQx5iUgimxCNpNzuCUYXuQrIM2VXa0qv2ONXCxu48e+iSMpCMA3EUFWU4+9Hhl/
         9na/5huzc30TzGrw0BAd//2KoJgxZd51UEmwE=
Content-Disposition: inline
In-Reply-To: <4F168266.3060205-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

Hello,

On Wed, Jan 18, 2012 at 04:27:18PM +0800, Li Zefan wrote:
> Furthermore, I noticed tmpfs also implemented xattr support, and we
> should be able to share most of the code, which makes the cost for
> having this feature smaller.

Yes, maybe, but tmpfs doesn't have any special semantics attached to
files.  It's supposed to store opaque data from userland.  Regardless
of code complexity, I just don't think this is a good idea.  What if
we later want to attach certain config meaning to or export statistics
via xattrs?  That would be quite unusual and require strong rationale
but at least fall in the similar usage as with the rest of the fs.

Thanks.

-- 
tejun
