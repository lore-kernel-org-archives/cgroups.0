From: Tom Hromatka <tom.hromatka@oracle.com>
Subject: Re: [PATCH] cpuset: remove set but not used variable 'cs'
Date: Wed, 7 Nov 2018 15:08:36 -0700
Message-ID: <7ac28cbe-56ec-3564-15fd-94acb4687150@oracle.com>
References: <1541575111-36000-1-git-send-email-wang.yi59@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=o7MXF7SJcrGL2SsNB+CG3fWVQmgawRKvWhfaxdjq4DI=;
 b=fbIL4G2Kh3SwPraFrPIzUwUo02qfEMRiT5fCOuE1OKiHChLHzolnsdwB0u/diX4FKQ4s
 INhAU7NOUtsuu1j2wj2Y9ytYTfStYWMh+BWSoBj0qWdzP12cA2vkTt/6wKbmsLMM1/ET
 9YI0aTDSzYfMG4CiUEU0TY+YEFRUm5144eHKNtkjle3UGrtHLCIYXYEagjZeURoJVXV9
 dSM14c620+7tqyMrRCNo/D9Y2aZy5+lAnvJzRDG+nD5wBZhVa/XrBZngxj91MG8w/NQ7
 JF2G4/D7OpTnnftAXl/Ka92GAsrbMJ+ToNkAiUVt8QS8RzzTPnjyN0WjbVcThwjA3U1u nQ== 
In-Reply-To: <1541575111-36000-1-git-send-email-wang.yi59@zte.com.cn>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yi Wang <wang.yi59@zte.com.cn>, lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, zhong.weidong@zte.com.cn

On 11/07/2018 12:18 AM, Yi Wang wrote:
> This fixes the following warning:
> kernel/cgroup/cpuset.c: In function ‘cpuset_cancel_attach’:
> kernel/cgroup/cpuset.c:1501:17: warning: variable ‘cs’ set but not used [-Wunused-but-set-variable]
>    struct cpuset *cs;
>                   ^
> 
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>


Reviewed-by: Tom Hromatka <tom.hromatka@oracle.com>


> ---
>   kernel/cgroup/cpuset.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 266f10c..784f948 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1498,10 +1498,8 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>   static void cpuset_cancel_attach(struct cgroup_taskset *tset)
>   {
>   	struct cgroup_subsys_state *css;
> -	struct cpuset *cs;
>   
>   	cgroup_taskset_first(tset, &css);
> -	cs = css_cs(css);
>   
>   	mutex_lock(&cpuset_mutex);
>   	css_cs(css)->attach_in_progress--;
> 

