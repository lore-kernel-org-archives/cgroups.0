From: Gang Li <ligang.bdlg@bytedance.com>
Subject: Re: Re: [PATCH v2] mm: oom: introduce cpuset oom
Date: Thu, 6 Apr 2023 21:02:17 +0800
Message-ID: <cc77d706-7baf-951b-13a5-3470c2b1bba9@bytedance.com>
References: <20230404115509.14299-1-ligang.bdlg@bytedance.com>
 <ZCw0sR6IqYa5Es7Q@dhcp22.suse.cz>
 <342c1967-8a68-275c-042e-765d5993157c@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680786142;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IfVjKlL+j9HlDI7Ywy3orPIREWTrRC6HkOIMTjgyE5A=;
        b=Qq/l6ip9dMiziIBWzW4ToFmAn29Ri9O4CLmtTYSR9Rz/boVf5FqBfGnqMOcOXdl871
         OQ7dEnKcBtY3M2meImEZvKvOfNu5wgcXc0gK7l8UePg0fbk2zzDD2tLyswobRChXf9sz
         A/8E0beNTT2d+D33WGr5dnvPoI3tTfvpEQKVKB7+wLndb6fqivDB9ogculITxgCfgcka
         VQAp/K5HfnUnuB57LNJBCVU6rDivf48a099xNNbdkQD9gvaSg+HM5hld30/hI+eeqo/y
         wGBxYExdN2uDvwnfyGVIYgKegzvoh1HRUajMaxoFVUSPb/bCVCJjcd8BHWltUMtqfOF6
         H+XQ==
Content-Language: en-US
In-Reply-To: <342c1967-8a68-275c-042e-765d5993157c@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Waiman Long <longman@redhat.com>
Cc: rientjes@google.com, linux-kernel@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, cgroups@vger.kernel.org

On 2023/4/5 01:24, Waiman Long wrote:
> 
> You will also need to take cpuset_rwsem to make sure that cpusets are 
> stable. BTW, the cpuset_cgroup_scan_tasks() name is kind of redundant. I 
> will suggest you just name it as cpuset_scan_tasks(). Please also add a 

mem cgroup oom use `mem_cgroup_scan_tasks`.
How about keep `cpuset_cgroup_scan_tasks` for naming consistency?

```
static void select_bad_process(struct oom_control *oc)
{
	oc->chosen_points = LONG_MIN;

	if (is_memcg_oom(oc))
		mem_cgroup_scan_tasks(oc->memcg, oom_evaluate_task, oc);
	else if (oc->constraint == CONSTRAINT_CPUSET)
		cpuset_cgroup_scan_tasks(oom_evaluate_task, oc);
	else {
		...
	}
}
```
