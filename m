From: Tejun Heo <tj@kernel.org>
Subject: Re: Please revert 4fd466eb46a6 ("HWPOISON: add memory cgroup filter")
Date: Tue, 28 Jan 2014 16:56:32 -0500
Message-ID: <20140128215632.GB16060@mtj.dyndns.org>
References: <20140128214524.GA16060@mtj.dyndns.org>
 <20140128215317.GC11821@two.firstfloor.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=anDnF6fS4PUFawuB06fc1urPe/3WBaeGG27h23F+05w=;
        b=KvcB/tZF8eD2xcBrNdfnphi9WiDXoM/bQ2CdMglRprTZP3/N8QMjH53u94HDG3xo8n
         erJuJhQbfvmfp44kmnP+3JKe5BAt9H1u3+h8C//4FaHfrymmy0D0jxb1VO79+Y98jcCH
         4NNUYmojUv0jJ+dP56DtYMpAGfd46ZZLYSuvtfqjwBfwanOEwQHWWCN6mNeByQ0nEySi
         sWSxng3/WnjZcmCPbryhQpZKEDPEDxNFxM568+H912wHJyF1c3POKchYin0TIypcErCv
         EYzNxJ14gFK+LA1W7IvOFpFPyK/tGSRZDH4nqzSZYoV0ZyOIpeL8MFapDJ3Th38X7soe
         XXCQ==
Content-Disposition: inline
In-Reply-To: <20140128215317.GC11821@two.firstfloor.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andi Kleen <andi@firstfloor.org>
Cc: Li Zefan <lizefan@huawei.com>, Wu Fengguang <fengguang.wu@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, gong.chen@linux.intel.com

On Tue, Jan 28, 2014 at 10:53:17PM +0100, Andi Kleen wrote:
> On Tue, Jan 28, 2014 at 04:45:24PM -0500, Tejun Heo wrote:
> > Hello, Andi, Wu.
> > 
> > Can you guys please revert 4fd466eb46a6 ("HWPOISON: add memory cgroup
> > filter"), which reaches into cgroup to extract the inode number and
> > uses that for filtering?  Nobody outside cgroup proper should be
> 
> Our test suite relies on it.

Hmmm?  Ooh, I thought this just went in during this -rc1 window.  This
was way back in 2009.  I suppose cgroup should expose an interface to
query inode then.  inos changing across remounts should be okay,
right?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
