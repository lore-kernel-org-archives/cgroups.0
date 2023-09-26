From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] selftests/cgroup: Fix awk usage in test_cpuset_prs.sh
 that may cause error
Date: Tue, 26 Sep 2023 08:18:17 -0400
Message-ID: <ed2993f2-4bdc-19c5-5a0f-1e96da44fb24@redhat.com>
References: <VI1P193MB07522BFC89B6B6DC5A89153999FCA@VI1P193MB0752.EURP193.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695730701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cFOa8v6HmzDuwfUtqIaAE2BKKG96nSYmL5UwcSOkLOQ=;
        b=dlRnsQZYIX0+iGdU3x/cOsnO7QfyBQCAqjIsCBU2J04/RcKEhQEcikt78Z96qcMM1/VJ4g
        MOTVG1CYXMvUtb86oVZ7usfR8OrkgR1Fo685vrbWWWtL5zQpfTqKqrgCnULjmmWgi+sHYU
        cUIuGVQSQ+lxQ2f9u7lamQkSQ1SqpdA=
Content-Language: en-US
In-Reply-To: <VI1P193MB07522BFC89B6B6DC5A89153999FCA-9HhAp6SO9BapRHe3RqZtslvRl+Y042/giGd9ebBGJoev3QGu/rdwKA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Juntong Deng <juntong.deng-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-mentees-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org

On 9/25/23 15:38, Juntong Deng wrote:
> According to the awk manual, the -e option does not need to be specified
> in front of 'program' (unless you need to mix program-file).
>
> The redundant -e option can cause error when users use awk tools other
> than gawk (for example, mawk does not support the -e option).
>
> Error Example:
> awk: not an option: -e
> Cgroup v2 mount point not found!
>
> Signed-off-by: Juntong Deng <juntong.deng-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>
> ---
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 4afb132e4e4f..6820653e8432 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -20,7 +20,7 @@ skip_test() {
>   WAIT_INOTIFY=$(cd $(dirname $0); pwd)/wait_inotify
>   
>   # Find cgroup v2 mount point
> -CGROUP2=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
> +CGROUP2=$(mount -t cgroup2 | head -1 | awk '{print $3}')
>   [[ -n "$CGROUP2" ]] || skip_test "Cgroup v2 mount point not found!"
>   
>   CPUS=$(lscpu | grep "^CPU(s):" | sed -e "s/.*:[[:space:]]*//")

Yes, the -e option is redundant. Thanks for catching that.

Acked-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

