From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET v2 block/for-next] writeback: prepare for cgroup
 writeback support
Date: Wed, 7 Jan 2015 10:11:54 -0500
Message-ID: <20150107151154.GB4395@htj.dyndns.org>
References: <1420572557-11572-1-git-send-email-tj@kernel.org>
 <20150107141945.GA29680@infradead.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=w/EzivF5zM5eq5Xge4chWyc+uvjr+vC8sxvSoy96EVc=;
        b=jHVCDrHDhwS7ZMgYVW3Rx6nYrcVp5y2sVutwmo5sN2VrIn/r9x979aXUiyUhwZ6iAu
         nWAJzHpsx1oKhpW1aoPefpUC2xrVSP2/GXCM30zomxzedztQj+XJmvI2029vragDeBA7
         MT0o/Yb5eACWfgsQNWuP9Ej7wFwcpZsK9jZu5bU6qfp3AKYF+hrvCEwEfyb6oim2c1oi
         P0d0hD879G6D7k8373QUckY/ubj5oK2Mg7WDtTZISvTa+PX+bDhNHH+ibsU1Lv6IQnTb
         dBkf4G5A5Anpj7FrssVCkUQH+I48ivqq8JVru4A1zTtBgC7JfIwG5oxH5huKWOjY4bqz
         DDVw==
Content-Disposition: inline
In-Reply-To: <20150107141945.GA29680@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz

Hello,

On Wed, Jan 07, 2015 at 06:19:45AM -0800, Christoph Hellwig wrote:
> This needs a rebase over my "backing_dev_info cleanups" series, which
> starts to sort out the bdi lifetime issues.  I think this series is

Shouldn't be a problem.

> fine to go over just that, but before any bigger bdi changes we'll
> also need to sort out the rest of the lifetime issues.  I have some
> WIP patches for that which I'll be able to post soon.

Sure, remaining uses should really pin everything down to the
request_queue.  That said, this patchset shouldn't affect the lifetime
management of bdi's.  Nothing spills out of bdi proper.

Thanks.

-- 
tejun
