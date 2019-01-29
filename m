From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 5/5] psi: introduce psi monitor
Date: Tue, 29 Jan 2019 11:44:31 +0100
Message-ID: <20190129104431.GJ28467@hirez.programming.kicks-ass.net>
References: <20190124211518.244221-1-surenb@google.com>
 <20190124211518.244221-6-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/DYnSP8wwfkVagxlcXdbh9VOXn6NyWlZWTa5ybGjpLI=; b=Jk0fptbwefzDq9+8zgftkY20d
        8S0HjEYx3W+J+CiaW3yCBRQi0gRLhDpQapl661tD+UD51GNxqwhk4DCEsUZTZO0URngSGCK5T59xD
        JtGj8ZWFL4Jt8tnkbUuNnyncF4lIH7sm7URnzzp9WO0be1AhK4U0uo8lmZy3mtvJPMwV9Rutb50Sv
        DVZ2ZTggkXUTqp2XPUldmoZJG04oFmB+wx66t18Imh0r+agjQTCJ0aK0nGIgFR9aCVHnHx969KoX0
        bG7U89mBgq3HA5cZqmkgbLkeTbk2UYHcFEhwAAs7mfqs7H41qw4fuQGDYKzQ+KPu/p4uasxvQIGQh
Content-Disposition: inline
In-Reply-To: <20190124211518.244221-6-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

On Thu, Jan 24, 2019 at 01:15:18PM -0800, Suren Baghdasaryan wrote:
>  static void psi_update_work(struct work_struct *work)
>  {
>  	struct delayed_work *dwork;
>  	struct psi_group *group;
> +	bool first_pass = true;
> +	u64 next_update;
> +	u32 change_mask;
> +	int polling;
>  	bool nonidle;
> +	u64 now;
>  
>  	dwork = to_delayed_work(work);
>  	group = container_of(dwork, struct psi_group, clock_work);
>  
> +	now = sched_clock();
> +
> +	mutex_lock(&group->update_lock);

actually acquiring a mutex can take a fairly long while; would it not
make more sense to take the @now timestanp _after_ it, instead of
before?
