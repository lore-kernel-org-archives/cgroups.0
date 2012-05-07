From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -V3 1/1] cgroup: Add inotify event on change tasks file
 (fork, exit, move pid from file)
Date: Mon, 7 May 2012 13:38:48 -0700
Message-ID: <20120507203848.GL19417@google.com>
References: <4F98E4E5.6020602@samsung.com>
 <4F98E57E.1040201@samsung.com>
 <20120427223455.GU26595@google.com>
 <4F9B82E1.3070602@samsung.com>
 <20120428214131.GB4586@mtj.dyndns.org>
 <4FA24E07.1010206@samsung.com>
 <1336075511.2320.2.camel@localhost>
 <4FA36818.9010409@samsung.com>
 <20120504170412.GD24639@google.com>
 <20120504174330.GS6871@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QL+2q9EmQFdJlSSvnpWCdJN+9L2PfMo8iNbko5P5j2Y=;
        b=nGYostahxpmp2iTVJomClm+k0NtWmxO18zRAlDX/KafDPkCULkDsL26ZndLVUlbpoc
         r8vTiFVCt7hG+lLLx+AOUQtnm4c+j0fEKNQFXyxEu/8Sx378NTGCPFwdH+Y51RpIZWiy
         k7bLuhxeIycDg7JMIq196tNgmRsJYGp3nARcrAOlNTOdgLqVH+Jg8EZUyw7ZADDoEX7x
         /5HP+Znme0BMK1k3vV8LM67kxwbYXpSyAKJ3EIr+6lvxw6Z36EKi0MvOKELbAme6I+cV
         3Agy0qWWcqDOqGn6u6WD0IlVvenP9BY7DBP+Iyerde0M5ezcTBGHfoWEGOBJsfnRVNPj
         1JDQ==
Content-Disposition: inline
In-Reply-To: <20120504174330.GS6871-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Dmitry Solodkiy <d.solodkiy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

On Fri, May 04, 2012 at 06:43:30PM +0100, Al Viro wrote:
> 	Consider that preemptively NAKed.  Eric, would you mind explaining
> WTF would fsnotify *do* with vfsmount(s) here, seeing that they might very
> well be not mounted in anyone's namespace?  And as for generating an event
> for each, they might appear and disappear at zero notice.

Eric, any ideas on how to proceed?

Thanks.

-- 
tejun
