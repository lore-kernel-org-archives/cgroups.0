From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Wed, 30 Jan 2019 09:06:58 -0800
Message-ID: <20190130170658.GY50184@devbig004.ftw2.facebook.com>
References: <20190128142816.GM50184@devbig004.ftw2.facebook.com>
 <20190128145210.GM18811@dhcp22.suse.cz>
 <20190128145407.GP50184@devbig004.ftw2.facebook.com>
 <20190128151859.GO18811@dhcp22.suse.cz>
 <20190128154150.GQ50184@devbig004.ftw2.facebook.com>
 <20190128170526.GQ18811@dhcp22.suse.cz>
 <20190128174905.GU50184@devbig004.ftw2.facebook.com>
 <20190129144306.GO18811@dhcp22.suse.cz>
 <20190129145240.GX50184@devbig004.ftw2.facebook.com>
 <20190130165058.GA18811@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r4FvnOpw+Kp/xo1E/oIUXzj02pZKaUP0vrX/v1MVF3s=;
        b=rQjmckmzAv1TtgaDTf+xwGnxDCZf/qt62fsajJvyFlBof5l/0CVKAG0/RQdHbYUU8Z
         YV3pupMl9wakI8GJ2a6Q6X1czRWRbqRIrvDYdBGenYJH/AT+DrU6hAeWiAJeKafhh47f
         jEDi7+H+xXmSLP+84wuhC/kTT1At/AlXUGMc7YbhpX92ShXurAJwHvoI1VXRc8cN2NoO
         uMKjdB5EwWa9+9c0xWSBmyKrQBV0LdzTOgzkmuI9iU0gbxpf1N+yxqips6zJE2ehg/yz
         2hltgR4GXOpilyhCa+c/RA4A40XOj85aph8KTQMtFbCHYe82rL28IeBb2qbM1WjpktGs
         JPnQ==
Content-Disposition: inline
In-Reply-To: <20190130165058.GA18811@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Hello, Michal.

On Wed, Jan 30, 2019 at 05:50:58PM +0100, Michal Hocko wrote:
> > Yeah, cgroup.events and .stat files as some of the local stats would
> > be useful too, so if we don't flip memory.events we'll end up with sth
> > like cgroup.events.local, memory.events.tree and memory.stats.local,
> > which is gonna be hilarious.
> 
> Why cannot we simply have memory.events_tree and be done with it? Sure
> the file names are not goin to be consistent which is a minus but that
> ship has already sailed some time ago.

Because the overall cost of shitty interface will be way higher in the
longer term.  cgroup2 interface is far from perfect but is way better
than cgroup1 especially for the memory controller.  Why do you think
that is?

> > If you aren't willing to change your mind, the only option seems to be
> > introducing a mount option to gate the flip and additions of local
> > files.  Most likely, userspace will enable the option by default
> > everywhere, so the end result will be exactly the same but I guess
> > it'll better address your concern.
> 
> How does the consumer of the API learns about the mount type?

It's gonna be a mount flag exposed in /sys/kernel/cgroup/features.

Thanks.

-- 
tejun
