From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 6/8] cgroup/cpuset: Change cpuset_rwsem and hotplug
 lock order
Date: Mon, 1 Jul 2019 07:51:07 -0700
Message-ID: <20190701145107.GY657710@devbig004.ftw2.facebook.com>
References: <20190628080618.522-1-juri.lelli@redhat.com>
 <20190628080618.522-7-juri.lelli@redhat.com>
 <20190628130308.GU3419@hirez.programming.kicks-ass.net>
 <20190701065233.GA26005@localhost.localdomain>
 <20190701082731.GP3402@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LFTfYGGYUeKgWu6NCW1YsTlwMbMp4Vwr1bzk+8Gz8Ak=;
        b=u6eQoeM91T1GCI/UJBC0PTS8/th7cOVcP1Y3qqK4wm082WjdLTINYfDSegCbbH0iIy
         xftsOaBnEV/aLRYWIfEqSg4YdcL7/7rfktZrTIs5YXvDgabZBDNDPubzgeYFgtJcLDwn
         WgoWPHd8GGaAJGSEPpu6sWSGMyKGwC5g+cFYCq9TJbP2WPgmMhJ/ypP8YlSH+/GDyDUu
         2UxATb5TSXhScqj/mBFaTvE1GAZy6JH5Y4hI27fpNNovd5WVC3uuTSVYM2nNQaOXyOIa
         tqjM/RzhIWFpZiJ90d7AMd9dOPlj1jY4uQ24Y6pyBFspwIv8CiR4NoEGZmWRsS9QMi58
         1TDg==
Content-Disposition: inline
In-Reply-To: <20190701082731.GP3402@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>, mingo@redhat.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org, Prateek Sood <prsood@codeaurora.org>

Hello,

On Mon, Jul 01, 2019 at 10:27:31AM +0200, Peter Zijlstra wrote:
> IIRC TJ figured it wasn't strictly required to fix the lock invertion at
> that time and they sorted it differently. If I (re)read the thread
> correctly the other day, he didn't have fundamental objections against
> it, but wanted the simpler fix.

Yeah I've got no objections to the change itself, it just wasn't
needed at the time.  We've had multiple issues there tho, so please
keep an eye open after the changes get merged.

Thanks.

-- 
tejun
