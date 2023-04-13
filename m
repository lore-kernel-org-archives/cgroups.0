From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Wed, 12 Apr 2023 14:03:32 -1000
Message-ID: <ZDdG1K0kTETZMTCu@slm.duckdns.org>
References: <20230412153758.3088111-1-longman@redhat.com>
 <ZDcGVebCpyktxyWh@slm.duckdns.org>
 <1ce6a073-e573-0c32-c3d8-f67f3d389a28@redhat.com>
 <ZDcS_yVCgh6g1LoM@slm.duckdns.org>
 <e38f72aa-9705-cf0c-a565-fb790f16c53e@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681344216; x=1683936216;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pyutDkp5jrSZUQ7ZSCUPusZLIPe20FEF4eoH9aQqT9U=;
        b=UKlpb+cigpV7szwbL/NVXYViJrjWbFojBNTvxQ7mTTikfFSfcMzWzCQ/O4yLyfeYs9
         WO+FSQoDv/VI5mgMKoG7fwDuIRcyUYxHZFF26GwFjPkzra8QQ2xneaHdJL2UKRZpxLlb
         9VwlEogRmjOA0vS2VLczf4zOgReqgfjKBg75G0sp3ItfvjEtC/YTb0O4vNOK03UxQobZ
         v8aLtuXqZMOaMsvMIa6w5TWdigol1d+Z6H8imco42YqyrD5ZFRFygRubmubuegyjtE0B
         O7tNapemKRqxRL0wgNEJUIPxjiYMC2tJoQnRgCCzywzU7RBEEuJ7YoXOCaWuXqw/WQBL
         jhdQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <e38f72aa-9705-cf0c-a565-fb790f16c53e@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>

Hello,

On Wed, Apr 12, 2023 at 04:33:29PM -0400, Waiman Long wrote:
> I think we can. You mean having a new "cpuset.cpus.isolated" cgroupfs file.
> So there will be one in the root cgroup that defines all the isolated CPUs
> one can have. It is then distributed down the hierarchy and can be claimed
> only if a cgroup becomes an "isolated" partition. There will be a slight

Yeah, that seems a lot more congruent with the typical pattern.

> change in the semantics of an "isolated" partition, but I doubt there will
> be much users out there.

I haven't thought through it too hard but what prevents staying compatible
with the current behavior?

> If you are OK with this approach, I can modify my patch series to do that.

Thanks.

-- 
tejun
