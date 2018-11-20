From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 3/7] cgroup: protect cgroup->nr_(dying_)descendants by
 css_set_lock
Date: Tue, 20 Nov 2018 08:18:18 -0800
Message-ID: <20181120161818.GT2509588@devbig004.ftw2.facebook.com>
References: <20181117003830.15344-1-guro@fb.com>
 <20181117003830.15344-4-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/OLQeObNGd0IBy4Pr7rtk0Du4O9Sp4NE2NCjWtQiVNQ=;
        b=OEx/fUP2CieC2K6VApF5yHUn4YOqeIzlNvYwkf80lGKgIssnrURiCic/xU5APVrMY0
         QKA7mjU7FJYaQ6KIpmJAJ2F8x1U02avEvLh/81vjdGx+XvIrVbEBpu0mrDHDAMW+iy7O
         sa5p3jneIpm76MYCxtx05hNVvA5rJb8fppb5MJXwuMch8AQneH1AkRM2ZzVyXhV6V1D+
         nUBZ0wm5jo+SycWHIyIA+x/I9tX396mKr6Dhlkx/cfCyXyjA1VMbcdaCUji/sEW4epFD
         1L4wSSZSwd9X6EnhliXT60nXyzLjyGiUHyj7yJInU3lRj+i9FnTOBop7/5apaQGEohmG
         UY2Q==
Content-Disposition: inline
In-Reply-To: <20181117003830.15344-4-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

On Fri, Nov 16, 2018 at 04:38:26PM -0800, Roman Gushchin wrote:
> Now the number of descendant cgroups and the number of dying
> descendant cgroups are synchronized using the cgroup_mutex.
> 
> The number of descendant cgroups will be required by the cgroup v2
> freezer, which will use it to determine if a cgroup is frozen
> (depending on total number of descendants and number of frozen
> descendants). It's not always acceptable to grab the cgroup_mutex,
> especially from quite hot paths (e.g. exit()).
> 
> To avoid this, let's additionally synchronize these counters
> using the css_set_lock.

Can you change it so that writes are cgroup_mutex and css_set_lock
protected and reads can be done under either cgroup_mutex or
css_set_lock?

Thanks.

-- 
tejun
