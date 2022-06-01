From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/2] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed, 1 Jun 2022 11:28:43 -1000
Message-ID: <YpfaC+wB5Th4tLDY@slm.duckdns.org>
References: <20220601165324.60892-1-longman@redhat.com>
 <20220601165324.60892-2-longman@redhat.com>
 <YpemVpvaPomwH7mt@slm.duckdns.org>
 <ca091a5c-4ae1-e973-403e-4086d4527102@redhat.com>
 <YpexWFptr/l2Y0rU@slm.duckdns.org>
 <bca31669-7107-ebe4-7fbf-2449940a5cc8@redhat.com>
 <c26f153c-304c-e109-6626-bb8b79a2e2ad@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XQUrno1u9BV9Hi8T4VSHF83kGe0TWlPtBJS9T7agQLs=;
        b=TMHlWNZfuujpslCtDUUYYkHjwexELIZXoM27hvWYqwVGP7r+7+3QJic0aHrV85RFxb
         tV8dJpD3fRLSfqZNqHIhLHW/vHaCZdxoMezRb6P7DxvsFrZZsY1TzA8898q+xCdiUW4E
         7QZX+Fyyot2d9D50TXYm5UKZ/Nd610xlj6uglmx8VFXyGIn3dw3XZkx70uSMXxIWrWIp
         DTWy4C7wliyAluKxGQ08T++L7+4XuppeWncfyJZqxOgnWkfIF4RpylCD6D11SmBTV3QN
         qiNuxGrWpXl3ix2Duf6XNEU8xrDF6udyOeO8niAseUGoQViv4yUXScbTQeA/MAdx+ek5
         Zgag==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <c26f153c-304c-e109-6626-bb8b79a2e2ad@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On Wed, Jun 01, 2022 at 05:25:53PM -0400, Waiman Long wrote:
> I think the best way to protect against blkg destruction is to get a percpu
> reference when put into lockless list and put it back when removed.
> 
> BTW, when I ran a test that continuously create and destroy containers, the
> total number of blkcg's kept on increasing. There are some freeing of
> blkcg's but no freeing of blkg's at all. Maybe we have a similar dying
> blkcg's problem here. I will take a further look at that when I have time.

They get pinned by per-cgroup writebacks which gets pinned by lingering page
cache and other remaining accounted memory areas, so I think they can hang
around if there's no memory pressure. But, yeah, it'd be great to verify
that they actually go away under memory pressure.

Thanks.

-- 
tejun
