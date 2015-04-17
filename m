From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Fri, 17 Apr 2015 16:42:06 -0400
Message-ID: <20150417204206.GI16743@htj.duckdns.org>
References: <1428799917-15141-1-git-send-email-cyphar@cyphar.com>
 <1428799917-15141-4-git-send-email-cyphar@cyphar.com>
 <20150413142439.GA2596@htj.duckdns.org>
 <CAOviyajqc_ip2Lpa5NTLLXxQ7JghYXg1UL3vXDdpbbnhmsfXEQ@mail.gmail.com>
 <20150414121732.GL2596@htj.duckdns.org>
 <CAOviyaj6eQ6s50+DrQN8yFAp7q5Y6b4ReFOT8XT0UufPb5J0xQ@mail.gmail.com>
 <20150417144519.GC1954@htj.duckdns.org>
 <CAOviyagcvtpDL1OONXR_-fX6X6N+-KfDw5mmpn=iQU+ZNps02g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=D1SiVeN1rKOANroBFmwqF8VtUUDVMeRvEPvz6e9jS0c=;
        b=a8SC+fFuMRpIVZH5F6Atlt7o26J2RqllTuToJ57i8RJeiJfJE+dfrnSFGzwfioMIOD
         9wOslpC/dwvwCr9tHDrCnN8sU5o5SurY/m/Xowr03h0MT1xMcseyrhzm0erqy0MvvTop
         Pc8DNNtb6CzKsuTzuex8aGpRjb5gJcuzNkRq114LvE1Ln3H8QPX6lM59Ak1Osb9u6Zj7
         LFzPR05FncIrlNDDDBFH8eS3cg0+K+raQj05ZGuENzto2tDv99p0j0UyfTFKpwXKoLhd
         qN+rS89RKXgKfIquGQ4edsxkMGO7JO0Cwlt+MZfbDI3pGpm07QyYsMGt6GMTDvBbHnSJ
         pgKQ==
Content-Disposition: inline
In-Reply-To: <CAOviyagcvtpDL1OONXR_-fX6X6N+-KfDw5mmpn=iQU+ZNps02g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Sat, Apr 18, 2015 at 06:35:41AM +1000, Aleksa Sarai wrote:
> >> Do you also want me to completely drop the COUNT macro? IMO it makes
> >> the CGROUP_<TAG>_COUNT consolidation much nicer.
> >
> > What's wrong with simply having start and end tags?
> 
> Because you'd have to write (CGROUP_TAG_END - CGROUP_TAG_START) every
> time? It's a small addition and it makes referencing the range of a
> tagged section much easier.

Wouldn't loops look more like

	for (subsys = CGROUP_TAG_START; subsys < CGROUP_TAG_END; subsys++)

And even if not, just define a separate macro for the length.  It's
not like we're gonna have a lot of tags.

Thanks.

-- 
tejun
