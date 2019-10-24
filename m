From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup: pids: use atomic64_t for pids->limit
Date: Thu, 24 Oct 2019 12:08:15 -0700
Message-ID: <20191024190815.GE3622521@devbig004.ftw2.facebook.com>
References: <20191016155001.13651-1-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cygSBSpbxOoz5DLta9pK9Fq8puzT/3arKPoGzp7XpzU=;
        b=uE+qV49XGr9hRYWnRoYqjv9vLqOEO1EcgYE+0tCeTsALBbePUu/hwpaNU4ffUZ1NWA
         LTbQ4vzlv66zSjjBMKaJ22ZpO41SzamYUkbAF1UiGVQXGodtZ8gRY00PAoOZ7T+kjEDm
         MNuWp+B01XnRIt2dTdeAK5ItWsPfeeaKands4plWQeR4KAH2ocQDPnyZbOTI/gPUEzDG
         9StD8w+esdZ8V5yFJXKy0JOZHNucUcWOB82VPa/e3kGsA6HhDh5hW4/hGxppi6z4t3tA
         Aw953Z+iso0hlCo9AlAkPMOP6zR+BtWewsRS2irIZONjwFIxBeDsV+ZkYZbuei8Whmzz
         F+Ow==
Content-Disposition: inline
In-Reply-To: <20191016155001.13651-1-cyphar@cyphar.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

On Thu, Oct 17, 2019 at 02:50:01AM +1100, Aleksa Sarai wrote:
> Because pids->limit can be changed concurrently (but we don't want to
> take a lock because it would be needlessly expensive), use atomic64_ts
> instead.
> 
> Fixes: commit 49b786ea146f ("cgroup: implement the PIDs subsystem")
> Cc: stable@vger.kernel.org # v4.3+
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>

Applied to cgroup/for-5.5.

Thanks.

-- 
tejun
