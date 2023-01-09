From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [External] Re: [PATCH v3] blk-throtl: Introduce sync and async
 queues for blk-throtl
Date: Mon, 9 Jan 2023 08:08:37 -1000
Message-ID: <Y7xYJfRLSMYk9tj9@slm.duckdns.org>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
 <20230105161854.GA1259@blackbody.suse.cz>
 <20230106153813.4ttyuikzaagkk2sc@quack3>
 <Y7hTHZQYsCX6EHIN@slm.duckdns.org>
 <c839ba6c-80ac-6d92-af64-5c0e1956ae93@bytedance.com>
 <Y7hlX4T1UOmQHiGf@slm.duckdns.org>
 <e499f088-8ed9-2e19-b2e5-efaa4f9738f0@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v8mDl6z8HZB+9Kmvxhak2TbVtn9xL/oPkERHONVaK/o=;
        b=IrAiD+WenjCOrXbXt8CHP0KM/kRGlzZglFdJYig8j5c+YduPyy214fU95mZg19YZkQ
         6If8TiMTCLETa696jiUhr8lxUtbHqo/oWKanSDA1M81PLYUn5V8qOopxrztev4v2o+xS
         V2WA8iphWw18eOMfI2BgQAfYq1ZX2nlK2k5EoWL9e5OUP6fgSnLqENq/CIg9Sh9q6iu4
         vV+CoMLnAbgl8Fzj2B+BU+TrePgajPu1J04qyNvFN2hRraF72WvETFCxK7Xy32dwolKT
         aKdW3jdopXXVKJ7gmLyeqSd2CfFnMBbrBjyC614BjE2lw+mf0XsK77jr5I5etdCJOh6A
         0MHA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e499f088-8ed9-2e19-b2e5-efaa4f9738f0-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

Hello,

On Sat, Jan 07, 2023 at 12:44:35PM +0800, hanjinke wrote:
> For cost.model setting, We first use the tools iocost provided to test the
> benchmark model parameters of different types of disks online, and then save
> these benchmark parameters to a parametric Model Table. During the
> deployment process, pull and set the corresponding model parameters
> according to the type of disk.
> 
> The setting of cost.qos should be considered slightly more，we need to make
> some compromises between overall disk throughput and io latency.
> The average disk utilization of the entire disk on a specific business and
> the RLA（if it is io sensitive） of key businesses will be taken as
> important input considerations. The cost.qos will be dynamically fine-tuned
> according to the health status monitoring of key businesses.

Ah, I see. Do you use the latency targets and min/max ranges or just fixate
the vrate by setting min == max?

> For cost.weight setting, high-priority services  will gain greater
> advantages through weight settings to deal with a large number of io
> requests in a short period of time. It works fine as work-conservation
> of iocost works well according to our observation.

Glad to hear.

> These practices can be done better and I look forward to your better
> suggestions.

It's still in progress but resctl-bench's iocost-tune benchmark is what
we're starting to use:

 https://github.com/facebookexperimental/resctl-demo/blob/main/resctl-bench/doc/iocost-tune.md

The benchmark takes like 6 hours and what it does is probing the whole vrate
range looking for behavior inflection points given the scenario of
protecting a latency sensitive workload against memory leak. On completion,
it provides several solutions based on the behavior observed.

The benchmark is destructive (to the content on the target ssd) and can be
tricky to set up. There's installable image to help setting up and running
the benchmark:

 https://github.com/iocost-benchmark/resctl-demo-image-recipe/actions

The eventual goal is collecting these benchmark results in the following git
repo:

 https://github.com/iocost-benchmark/iocost-benchmarks

which generates hwdb files describing all the found solution and make
systemd apply the appropriate configuration on boot automatically.

It's still all a work in progress but hopefully we should be able to
configure iocost reasonably on boot on most SSDs.

Thanks.

-- 
tejun
