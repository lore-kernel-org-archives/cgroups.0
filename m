From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-4.4 3/3] cgroup: replace unified-hierarchy.txt
 with a proper cgroup v2 documentation
Date: Thu, 22 Oct 2015 23:36:05 +0900
Message-ID: <20151022143605.GE30579@mtj.duckdns.org>
References: <20151022012212.GA20931@mtj.duckdns.org>
 <20151022012302.GB20931@mtj.duckdns.org>
 <20151022012354.GC20931@mtj.duckdns.org>
 <20151022143427.GC20847@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=uvHTSqmMcGDyNqf33h0Dpw/wby72ALnaPOijoVo/4Is=;
        b=QDzPdg2vQ7qvvtdwvQMRwVCdUw2Q5b3iMeKPJO0xTFrFPrzKYVz0FAXW9j9Jb3NL9l
         HyiKLWNW91NijeBqPUkazzghu1kc4ESv+FpBxTLwOBPneFcB2vughkm2H75RpAfU9vqc
         u+4qchvnlkE1qhbjXXouXAp6oZadyv2mp9oC4qJGhEaRJuwLMaOLRBPejW85V1qyF7Wf
         Em3mlH+y1/z5o0yUnrA+XOPs80lej5tMTmCPVU3q+XzauWcRZ2dfj7ietYsUChc3TBxX
         UHf2NW6yom6eIO8bI8emLXV3pwCFsk6hRQr4nB5vIHLD1B8g9hD+UzF8SHpgpNlKTdjK
         LswA==
Content-Disposition: inline
In-Reply-To: <20151022143427.GC20847@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Michal Hocko <mhocko@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Paul Turner <pjt@google.com>, kernel-team@fb.com

On Thu, Oct 22, 2015 at 10:34:27AM -0400, Vivek Goyal wrote:
> On Thu, Oct 22, 2015 at 10:23:54AM +0900, Tejun Heo wrote:
> 
> [..]
> > +5-3-2. Writeback
> > +
> > +Writeback of page cache manages the dirty memory ratio and is an
> > +integral part of memory management.  The io controller, in conjunction
> > +with the memory controller, implements control of page cache writeback
> > +IOs.  The memory controller defines the memory domain that dirty
> > +memory ratio is calculated and maintained for and the io controller
> > +defines the io domain which writes out dirty pages for the memory
> > +domain.
> 
> Hi Tejun,
> 
> Glad that finally devel flag will go away and new shiny unified hierarchy
> can be used using cgroup2 fstype. Thanks for all this hard work.
> 
> Will it make sense to also talk about what filesystems currently writeback
> cgroup work with. IIUC, currently this works with ext2 and there are plans to
> make it work with other filesystems.

It works with ext2 and 4 and btrfs.  Will document it.  Thanks.

-- 
tejun
