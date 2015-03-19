From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 RESEND 0/4] cpusets,isolcpus: exclude isolcpus from
 load balancing in cpusets
Date: Thu, 19 Mar 2015 14:30:01 -0400
Message-ID: <20150319183001.GD19657@htj.duckdns.org>
References: <1425917530-1771-1-git-send-email-riel@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1TmFDreLqUZ90ZOiSRL0Gce4vkDcxWHxWrQklRGLVmM=;
        b=tVLVa/ztph3ryqpKnOmKqgIAI2O+M7Z1fuJ1D63jITrks11gQSj0L1CuuDMtAigU38
         XBhNDMy1YdV10pR8Cx1b97ccpf5GTSF7qQbW6oz+77d1j2QAfH2n0v91FNkPcEB2nvcH
         3J377fJZA8Nlqnmi+CNRe8kAi2V9Vy6ak6b+ZoHO5f/vZLlMGftKw4vpCm6nD40gCJB/
         cvhjtKpmN8TMxgV/RUWmHUluY3N7ynQ8x2UztOHXUokflX+oBxGsj0yiXOshy3+Wu/jM
         cynbe33h/0k9CBudg4kH78i+gB7EpQO0CQIkaWIghcx+DMYgDFqtFmX/6p20eEUDzCyB
         Ow+A==
Content-Disposition: inline
In-Reply-To: <1425917530-1771-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com

On Mon, Mar 09, 2015 at 12:12:06PM -0400, riel@redhat.com wrote:
> Ensure that cpus specified with the isolcpus= boot commandline
> option stay outside of the load balancing in the kernel scheduler.
> 
> Operations like load balancing can introduce unwanted latencies,
> which is exactly what the isolcpus= commandline is there to prevent.
> 
> Previously, simply creating a new cpuset, without even touching the
> cpuset.cpus field inside the new cpuset, would undo the effects of
> isolcpus=, by creating a scheduler domain spanning the whole system,
> and setting up load balancing inside that domain. The cpuset root
> cpuset.cpus file is read-only, so there was not even a way to undo
> that effect.
> 
> This does not impact the majority of cpusets users, since isolcpus=
> is a fairly specialized feature used for realtime purposes.
> 
> This version fixes the UP compilation issue, in the same way done
> for the other cpumasks.

Applied 1, 2, and 4 to cgroup/for-4.1.  I collected the acks from the
previous threads.  Can you please collect them when posting new
revisions in the future?

Thanks.

-- 
tejun
