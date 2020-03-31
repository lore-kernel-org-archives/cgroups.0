From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 0/4] Add support Weighted Round Robin for blkcg and
 nvme
Date: Tue, 31 Mar 2020 10:36:35 -0400
Message-ID: <20200331143635.GS162390@mtj.duckdns.org>
References: <cover.1580786525.git.zhangweiping@didiglobal.com>
 <20200204154200.GA5831@redsun51.ssa.fujisawa.hgst.com>
 <CAA70yB5qAj8YnNiPVD5zmPrrTr0A0F3v2cC6t2S1Fb0kiECLfw@mail.gmail.com>
 <CAA70yB62_6JD_8dJTGPjnjJfyJSa1xqiCVwwNYtsTCUXQR5uCA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g8eJTubDOpnYx+MtqM441enT6egVrVa4bYoBdzCqVy0=;
        b=VWvb+6VE6Bc3z/zRovKdw8FPguqnvnIL0uwajhY5uXtucaCe7G5c85lThPb8hTYhn9
         PHL8UjRnU/deAljnmmbMJgW8hSM1swVCyNW2OW6VVgfDQlYLeOzIN1ms85bXnrPLVjfp
         gURscr2MPffBwbRimGGc39gyNwgkkPSUHcXIpF981uDN/xVlURsl2L+jZJHEP9Q6N2/U
         0RmjKDv3e33dDDCV6KBvznLJ9FFRCF2gp7g8UX6Ot84jVjOCu1VjPLF4rq4xCRpxW6/m
         xc+sGYdo5GiXmo7cVGmvFQ5PPwcti5+DYPEvSt181iW17IaYwwGdANqpdxCjzS8sEHn/
         kPWQ==
Content-Disposition: inline
In-Reply-To: <CAA70yB62_6JD_8dJTGPjnjJfyJSa1xqiCVwwNYtsTCUXQR5uCA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Weiping Zhang <zwp10758-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Keith Busch <kbusch-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Minwoo Im <minwoo.im.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nadolski, Edmund" <edmund.nadolski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org

Hello, Weiping.

On Tue, Mar 31, 2020 at 02:17:06PM +0800, Weiping Zhang wrote:
> Recently I do some cgroup io weight testing,
> https://github.com/dublio/iotrack/wiki/cgroup-io-weight-test
> I think a proper io weight policy
> should consider high weight cgroup's iops, latency and also take whole
> disk's throughput
> into account, that is to say, the policy should do more carfully trade
> off between cgroup's
> IO performance and whole disk's throughput. I know one policy cannot
> do all things perfectly,
> but from the test result nvme-wrr can work well.

That's w/o iocost QoS targets configured, right? iocost should be able to
achieve similar results as wrr with QoS configured.

> From the following test result, nvme-wrr work well for both cgroup's
> latency, iops, and whole
> disk's throughput.

As I wrote before, the issues I see with wrr are the followings.

* Hardware dependent. Some will work ok or even fantastic. Many others will do
  horribly.

* Lack of configuration granularity. We can't configure it granular enough to
  serve hierarchical configuration.

* Likely not a huge problem with the deep QD of nvmes but lack of queue depth
  control can lead to loss of latency control and thus loss of protection for
  low concurrency workloads when pitched against workloads which can saturate
  QD.

All that said, given the feature is available, I don't see any reason to not
allow to use it, but I don't think it fits the cgroup interface model given the
hardware dependency and coarse granularity. For these cases, I think the right
thing to do is using cgroups to provide tagging information - ie. build a
dedicated interface which takes cgroup fd or ino as the tag and associate
configurations that way. There already are other use cases which use cgroup this
way (e.g. perf).

Thanks.

-- 
tejun
