From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] kselftest/cgroup: Fix gathering number of CPUs
Date: Mon, 14 Nov 2022 15:16:28 +0530
Message-ID: <96eeeb5e-9fe9-ebf6-cc91-d49c86ec615d@oracle.com>
References: <20221113114449.18693-1-leitao@debian.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=F1zDETyuNtfyPDklupL/t+SahmqvPeLwlWGnau78gwc=;
 b=Sx7vaj9OsaULxBJQQo2LxWtkYXVit04IAUdQUjXqtsJDSHyfx5qXDK7UU4MzcxwRr23w
 ipSLu5Qob1F1CrnZaA1XlG67uIsdPSjHteegRwkQLpBch6umJz5xaNyO6f1x6uKIzMpk
 jfN6i/+wXGVoOJcho4fvbXSj/kmLOTVemzkela6yNdvVj0Q+foblTxDfYnVZgUq547Wz
 2nFctcWAduTQnysO0qqvElyZAgYAaoVd0quZ6dPYQcmlIWTfx+E1+4WUkMhI6AT/PYfX
 FuRi+EfQHrMzTQakyxEAajM+WKNRMjLQLH9PaekIVb3wK/cxoAWQqOlLPKlnwdkwsvy5 Hw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1zDETyuNtfyPDklupL/t+SahmqvPeLwlWGnau78gwc=;
 b=o/Qxcf6yBBXx7fxaj1ZzEvUSni8mVQLDIA1jobs45tHKN7wC/sWYnLL79Cbt5RoP7itWaBKjNMVzEYfm9MDtA4jSR7OVLdMFuZuQIuSdIfYBV6dgayo8l4nN2Q0zlvfmiYrsIfRJRCnPPMhCL5b0fKZS+oo78vNZOahLug+BWKc=
Content-Language: en-US
In-Reply-To: <20221113114449.18693-1-leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leit-M8Ki61LpUEw@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 11/13/22 17:14, Breno Leitao wrote:
> test_cpuset_prs.sh is failing with the following error:
> 
> 	test_cpuset_prs.sh: line 29: [[: 8
> 	57%: syntax error in expression (error token is "57%")
> 
> This is happening because `lscpu | grep "^CPU(s)"` returns two lines in
> some systems (such as Debian unstable):
> 
> 	# lscpu | grep "^CPU(s)"
> 	CPU(s):                          8
> 	CPU(s) scaling MHz:              55%
> 
> This is a simple fix that discard the second line.
> 
> Signed-off-by: Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>

Tested with util-linux v2.38

Reviewed-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> ---
>  tools/testing/selftests/cgroup/test_cpuset_prs.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 526d2c42d870..564ca8c33035 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -25,7 +25,7 @@ WAIT_INOTIFY=$(cd $(dirname $0); pwd)/wait_inotify
>  CGROUP2=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
>  [[ -n "$CGROUP2" ]] || skip_test "Cgroup v2 mount point not found!"
>  
> -CPUS=$(lscpu | grep "^CPU(s)" | sed -e "s/.*:[[:space:]]*//")
> +CPUS=$(lscpu | grep "^CPU(s):" | sed -e "s/.*:[[:space:]]*//")
>  [[ $CPUS -lt 8 ]] && skip_test "Test needs at least 8 cpus available!"
>  
>  # Set verbose flag and delay factor

-- 
Thanks,
Kamalesh
