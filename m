From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cpuset: Fix incorrect memory_pressure control file
 mapping
Date: Thu, 24 Aug 2017 09:45:24 -0700
Message-ID: <20170824164524.GR491396@devbig577.frc2.facebook.com>
References: <1503590669-16601-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O43emt/8LvhSce92Dru+abM4QNlj1pf0/D2yE6HWmHY=;
        b=jelEpoC0o3UV4rLu8DLu51YQBHWEwmp9m1Bth7DtV0FuX61yfJmjI5tmzKN6xp+Bq4
         kvsJM6K6sr6aLOf1CJQW5baSzNltwEDaj5IJVP6BnY+IuisIxuXVXOh5mcGmbDhM7gZy
         WOocpf9WSia5hFybQzDni/r+KtpnCLc0Aqq0WO1I2DTElOpgC6BhEgXC2j7xJWgjSjdS
         8t25dRxLsuIAiuxoLmYeC1H/f7r0tLxXAxL7bUP8GS+RpoPde8kWbQ+ftcSVky5pWzic
         jpaMTW5Ijr+Wu72S/mq95Dv49EC4Iie0y8q2sG9cCaO4mLqi7RzO0Xzujs1SNm5opXe9
         tQsA==
Content-Disposition: inline
In-Reply-To: <1503590669-16601-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 24, 2017 at 12:04:29PM -0400, Waiman Long wrote:
> The memory_pressure control file was incorrectly set up without
> a private value (0, by default). As a result, this control
> file was treated like memory_migrate on read. By adding back the
> FILE_MEMORY_PRESSURE private value, the correct memory pressure value
> will be returned.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Oops, applied to cgroup/for-4.13-fixes w/ stable cc'd.  I broke it way
back in v4.4 which makes me wonder whether anybody is actually using
it.

Thanks a lot for catching it.

-- 
tejun
