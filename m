From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Suggestion] kernel: cgroup: mount failure in LTP
 cgroup_regression_test.sh
Date: Fri, 22 Nov 2013 00:49:20 -0500
Message-ID: <20131122054920.GA32700@mtj.dyndns.org>
References: <527C9D9B.8090802@asianux.com>
 <20131120173549.GO28946@htj.dyndns.org>
 <528D6E19.4080100@gmail.com>
 <528D89AA.6080102@gmail.com>
 <551116969.38084288.1385021094494.JavaMail.root@redhat.com>
 <20131121152645.GB3352@htj.dyndns.org>
 <1639659702.38807133.1385075581222.JavaMail.root@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6rH/S1qHhh/NM2UGY+TbFetre6cmbdKiB+FdJZ4do7A=;
        b=HdIIrwoHstwzDVf+UCf2NkkD68pBoLuRpFBIrzrlKPpA4bCyGis5rOTC40NVeXCDzK
         wsTS4tzmtNp/FucJliOmtWAZnwG7+NJGe05leStOCb8DzVa647ZBaAXFnW7yQwS309l5
         +11cE1HENrxyUAVWct6WmJBZqvEnm7LTpBnXSR3d4POvcE+BFrnUkxJUn1H9/a5vq1Xc
         MxSJJIFVA2r8U32a5Elcy/6vIi9c5I/BA6N+TOGsrEg1eAFhgm47BVBo8zl1ajgQMEQH
         /UiGcR3cpUhXdHOenHGFz/SfUInoDA5I3jQWAHArBq6FD4mkjQ6xr7rsONikfnlb4DBE
         KtLw==
Content-Disposition: inline
In-Reply-To: <1639659702.38807133.1385075581222.JavaMail.root-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Stancek <jstancek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, gaowanlong-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, chris-8NJIiSa5LzA@public.gmane.org, mitani-Czb31pHLG9l3+QwDJ9on6Q@public.gmane.org, lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Nov 21, 2013 at 06:13:01PM -0500, Jan Stancek wrote:
> I believe the test always respected this requirement. Problem we see
> is because of initial state of the system. Test appears to expect
> that it is able to mount cgroups freely, but they are already in use.
> 
> > Would it be possible to update LTP accordingly?
> 
> I'm not sure the test can do anything (other than not run at all).
> 
> Other option is to setup system in a way where cgroups are not in use
> prior to running this test, though this may not be possible with systemd.

You can tell systemd to not mount any controllers.

Thanks.

-- 
tejun
