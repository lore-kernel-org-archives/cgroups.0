From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/cpuset: simplify the percpu kthreads check in
 update_tasks_cpumask()
Date: Mon, 10 Jul 2023 10:25:21 -1000
Message-ID: <ZKxpMRwNpnNTmYN5@slm.duckdns.org>
References: <20230704113049.1019118-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689020723; x=1691612723;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qUELfvlg4gHGwdGYe8YxWDx5h185SGtFxuTpLn1TdkI=;
        b=s3s8DqVP/I2FnyZ3aJrDYkuPF989n9Zuc82IwqVsWDs07HIWbqnO10HdkwYkeBRvV0
         uJSsrC7vkOnM2jz/q7KFV3j4MpxSIZpL23FWotrmEN21IMK8PB8Iz+TehPKkwdrQ+/VN
         PGD7VVUg/QfdXtSnwNC+zZrZNhzPkygySADBXL5cbQcRU2bp8hrEG1Afc+9B3E4eoDBd
         XmTtNHY4yiXJ7+uEr93gHmFamSrTQpFz9lWx8FLihNYvuBNrAyXU6/Xz6cy6aild6aqS
         DmebHhe3LiLMs1r2slNhlouZOvrQB1D6E9wnsM9rlSe/UvQ0mdsJzk5nm3y7VKQubXgL
         r9gQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230704113049.1019118-1-linmiaohe@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: longman@redhat.com, hannes@cmpxchg.org, lizefan.x@bytedance.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jul 04, 2023 at 07:30:49PM +0800, Miaohe Lin wrote:
> kthread_is_per_cpu() can be called directly without checking whether
> PF_KTHREAD is set in task->flags. So remove PF_KTHREAD check to make
> code more concise.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
