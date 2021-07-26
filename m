From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 4/9] cgroup/cpuset: Enable event notification when
 partition become invalid
Date: Mon, 26 Jul 2021 13:14:12 -1000
Message-ID: <YP9BxKXfhaoTE+LO@slm.duckdns.org>
References: <20210720141834.10624-1-longman@redhat.com>
 <20210720141834.10624-5-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XlqO27qrjwfCjHyqQRAvgHsZUjwQ3+Wx+UdEzbB2q48=;
        b=fRN69KFrOsFKhC2wPvWFRZ/lnteV9fg9+31gTf41zkgI2F9buQPBEFwJzW0MB6O4Oe
         wbOo2wBtauY2JNE2Es8k6waNss5Vw0BX8xPVea3oDO4fJ9jKOr6sS2LHoo1y8K4sbxyZ
         1trKsdUAnNYAkpcNBgYH9+nRiZCRSZ/UvkUVXsc83HoWX7WotrEGFSs1PESiqR750pF8
         tCF5b2p30Bz6nwkKpK9sadVCdlO78fny0DclfIdUzp84h3/7cRl5qvq+NOab7ih1QhKb
         GJghNMn5cAfg603IjJOMJ9TNzkWgepc3XsApEKc0WIIn8wkYKYyAefE2xCMayBhi9Idb
         kH4A==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210720141834.10624-5-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

On Tue, Jul 20, 2021 at 10:18:29AM -0400, Waiman Long wrote:
> +static inline void notify_partition_change(struct cpuset *cs,
> +					   int old_prs, int new_prs)
> +{
> +	if ((old_prs == new_prs) ||
> +	   ((old_prs != PRS_ERROR) && (new_prs != PRS_ERROR)))
> +		return;
> +	cgroup_file_notify(&cs->partition_file);

I'd generate an event on any state changes. The user have to read the file
to find out what happened anyway.

Thanks.

-- 
tejun
