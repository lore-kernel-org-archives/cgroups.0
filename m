From: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible bug - LTP failure for memcg
Date: Thu, 14 May 2015 16:44:20 +0200
Message-ID: <20150514144420.GA12884@rei>
References: <55536DC9.90200@kyup.com>
 <20150514092145.GA6799@dhcp22.suse.cz>
 <20150514103148.GA5066@rei.suse.de>
 <20150514115641.GE6799@dhcp22.suse.cz>
 <20150514120142.GG5066@rei.suse.de>
 <20150514121248.GG6799@dhcp22.suse.cz>
 <20150514123816.GC6993@rei>
 <20150514143039.GI6799@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150514143039.GI6799-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi!
> Signed-off-by: Michal Hocko <miso-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>

                                 ^
			       forgotten git config user.email?
> ---
>  testcases/kernel/controllers/memcg/functional/memcg_function_test.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh b/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh
> index cfc75fa730df..399c5614468a 100755
> --- a/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh
> +++ b/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh
> @@ -211,8 +211,8 @@ testcase_29()
>  	echo $pid > tasks
>  	kill -s USR1 $pid 2> /dev/null
>  	sleep 1
> -	echo $pid > ../tasks

This change breaks the testcase on older kernels:

./memcg_function_test.sh: line 215: echo: write error: Device or resource busy
memcg_function_test   29  TFAIL  :  ltpapicmd.c:190: force memory failed

$ uname -r
3.0.101-0.35-default

> +	# This expects that there is swap configured
>  	echo 1 > memory.force_empty
>  	if [ $? -eq 0 ]; then
>  		result $PASS "force memory succeeded"
> @@ -225,7 +225,7 @@ testcase_29()
>  
>  testcase_30()
>  {
> -	$TEST_PATH/memcg_process --mmap-anon -s $PAGESIZE &
> +	$TEST_PATH/memcg_process --mmap-lock2 -s $PAGESIZE &
>  	pid=$!
>  	sleep 1
>  	echo $pid > tasks

This part is OK.

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
