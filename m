From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Mon, 6 Feb 2023 15:03:05 -1000
Message-ID: <Y+GjSTu9vE/A/EKG@mtj.duckdns.org>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <c7b5e502d1a3b9b8f6e96cbf9ca553b143c327e0.1675669136.git-series.apopple@nvidia.com>
 <Y+Fttp1ozejoSQzl@slm.duckdns.org>
 <CAJD7tkb_Cr7rTTpKc1VBpS8h=n3Hu+nGiV8dkLH-NdC1bSG9mg@mail.gmail.com>
 <Y+GA6Y7SVhAW5Xm9@slm.duckdns.org>
 <CAJD7tka6SC1ho-dffV0bK_acoZd-5DQzBOy0xg3TkOFG1zAPMg@mail.gmail.com>
 <24668a43-fb00-5240-6072-230c5f5d0943@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=imn/r+cGKKMSLDP+bAG1xH00VwxyZVzwdCmOeTkk6YA=;
        b=khb4QZQABICsRfT0uDHHbVzA3UBTkoSIM+PpBu5YmfkTOAxqLsLVa1aTVdtzG3Ky2k
         nKQgfiI1azs2+BcZYDC+Gycsy4iDLHVVr3TKWabwrX9b23qV7sMWIHQHdcyCgx/ADfik
         huGHRYbM6/KNcYgxL0UNluXr1VuYJVz18kghNCNtRIk/RdZbE9A1HDC5j6q3QgmiqVQW
         Pw3V4PGQFYzX7R4hgnpmLjZuY2cLjhNla7okQdtM3of0G5ogtwdosidAfWO6J9WKdhjj
         Dy7hGLwxzCA9CIjm+MbrBvfXHW1uugbEDNmXv67msNloH/WE9TsHIBKAy5ij6lVf9foa
         4unA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <24668a43-fb00-5240-6072-230c5f5d0943@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, "Daniel P . Berrange" <berrange@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>

On Mon, Feb 06, 2023 at 08:00:54PM -0500, Waiman Long wrote:
> If it should not be part of the memcg, does it make sense to make it a
> resource in the existing misc controller? I believe we don't want a
> proliferation of new cgroup controllers.

Yeah, if it's gonna be an independent knob, I suppose so, but I really think
the locked accounting should be tied to the page, which mostly likely would
mean that it'd be tied to the page ownership too making its natural place
memcg.

Thanks.

-- 
tejun
