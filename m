From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cpuset: handle race between CPU hotplug and
 cpuset_hotplug_work
Date: Tue, 13 Sep 2016 11:27:38 -0400
Message-ID: <20160913152738.GB21123@htj.duckdns.org>
References: <20160912040547.k3qtivdcet6p4mel@codeaurora.org>
 <1473653698-29681-1-git-send-email-joonwoop@codeaurora.org>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qjpF0CONwAm2ncErw6ZPZ/hS9IXzy0w+lRPvh0P2HkE=;
        b=p62AmMTF+qU/iSocjoevOuWDy2FvD+3Sc6EwTs7Oo/rDW9SOxJecUTcT/aPEAaf4Qz
         orU+oZQoffHgKK9U4QUNMx5orJTcM2KAj2lUSElNQWYaBijDpy/DhdaDEGSN1jDtVhJf
         /wljtunQHwrALpukjK1z02ymOsf62xrAY2ydS9bR3YVRmuzOYLql/OnNYq9Gi0wUtmx/
         E+E3iJSV4hR2s/5tFWcfu23PvSmCfdMQonQPdjMI+bFPz1M1ZSD8obWSaQ5gk+Q4hxPM
         56xWkhPDXUjHT+hqtcizhccSzjoQ2ynSwFIH+YJwpiS+QMPSQHorKIZvX59RlbfrC6wE
         925g==
Content-Disposition: inline
In-Reply-To: <1473653698-29681-1-git-send-email-joonwoop@codeaurora.org>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joonwoo Park <joonwoop@codeaurora.org>
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

On Sun, Sep 11, 2016 at 09:14:58PM -0700, Joonwoo Park wrote:
> A discrepancy between cpu_online_mask and cpuset's effective_cpus
> mask is inevitable during hotplug since cpuset defers updating of
> effective_cpus mask using a workqueue, during which time nothing
> prevents the system from more hotplug operations.  For that reason
> guarantee_online_cpus() walks up the cpuset hierarchy until it finds
> an intersection under the assumption that top cpuset's effective_cpus
> mask intersects with cpu_online_mask even with such a race occurring.
> 
> However a sequence of CPU hotplugs can open a time window, during which
> none of the effective CPUs in the top cpuset intersect with
> cpu_online_mask.

Applied to cgroup/for-4.8-fixes.

Thanks.

-- 
tejun
