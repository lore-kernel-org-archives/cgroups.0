From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.15-fixes] cgroup: fix css_task_iter crash on
 CSS_TASK_ITER_PROC
Date: Mon, 8 Jan 2018 06:56:16 -0800
Message-ID: <20180108145616.GU3668920@devbig577.frc2.facebook.com>
References: <39625861-99c0-1c15-08a6-49b9d678c4c2@redhat.com>
 <20171213152914.GN3919388@devbig577.frc2.facebook.com>
 <121dc065-89ba-98ab-68ff-e86f1a636b06@redhat.com>
 <20171213213756.GX3919388@devbig577.frc2.facebook.com>
 <20171220151331.GA3413940@devbig577.frc2.facebook.com>
 <87lgh8d5gg.fsf@czerwinskis.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zYdGgv+aE0ygfhDTS6DlRDshtIosaVTF/I2Pv0q3PHA=;
        b=LEDb1oyLam/sw/yp0phoaHC9bkqWMavQg0KhgszjRHmPSUky8Q9ucWHo1/Ttv692mC
         +/JrEEA00NEtM3PE01MOJurS+Jc+eA7oNZahwtvk889TO0aewWnWv8DchiUPLVIdmXvQ
         UxsnINDgnh+MLIWWG3GumzjHBcjKwePb9Jfnf4yidHp8oeZXBbMiYfej6ZEMHMUll0NU
         GAnnrfmWTrtkgNYE8kLU0hEzw6vbTXNGHCPH2e/n68cLK90HpZIWWLHWG6bl2NpeEOEI
         wJAciIt8FDg52QRc9LHaxfIhuFSYG1YvES+3lmCksfm3aGyW1OTzcBVkMGXRc3572FMw
         Ayag==
Content-Disposition: inline
In-Reply-To: <87lgh8d5gg.fsf-FCEtQH5z4SoXQnBnI9m10w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rouven Czerwinski <rouven-FCEtQH5z4SoXQnBnI9m10w@public.gmane.org>
Cc: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, regressions-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org, Bronek Kozicki <brok-CgwIDsGnGWjby3iVrkZq2A@public.gmane.org>, George Amanakis <gamanakis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Jan 08, 2018 at 11:12:47AM +0100, Rouven Czerwinski wrote:
> Hello, 
> 
> Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
> 
> > Applied the following to cgroup/for-4.15-fixes.  Will push out to
> > linus later this week. [...] 
> 
> I can't find your fixes in master yet, did you perhaps forget to push
> out?

Thanks for reminding me.  Sent out the pull request.

Happy new year!

-- 
tejun
