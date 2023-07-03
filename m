From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/3] selftests: cgroup: Minor code reorganizations
Date: Mon, 3 Jul 2023 14:01:26 -0400
Message-ID: <4bae7852-61b9-999d-765d-a8f0d0084256@redhat.com>
References: <20230703172741.25392-1-mkoutny@suse.com>
 <20230703172741.25392-3-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688407292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iFe8atToFS2utTEa2xH/lGx0LLo+DpKgRn21BdsYeHk=;
        b=Eyj1tDRyX0v/X1G7HWQ0vIq+wc3fuT/nG2rPE6RZkaFyf9HOCNiSfB8i9S/bYI7wUXKNKR
        Yk+L1Scm4gPsJzQDVwDSX3IxhxOI42YZ3/7k60P66OeBpcqJ1oqgPe+MWOGckGoOXyJaoL
        qSn8j2py6Lf2+i765NJSzNmjvaArBfY=
Content-Language: en-US
In-Reply-To: <20230703172741.25392-3-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


On 7/3/23 13:27, Michal Koutný wrote:
> No functional change intended, these small changes are merged into one
> commit and they serve as a preparation for an upcoming new testcase.
>
> Signed-off-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>
> ---
>   MAINTAINERS                                       | 1 +
>   tools/testing/selftests/cgroup/cgroup_util.c      | 2 ++
>   tools/testing/selftests/cgroup/cgroup_util.h      | 2 ++
>   tools/testing/selftests/cgroup/test_core.c        | 2 +-
>   tools/testing/selftests/cgroup/test_cpuset_prs.sh | 2 +-
>   5 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e0976ae2a523..03bec83944c4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5260,6 +5260,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
>   F:	Documentation/admin-guide/cgroup-v1/cpusets.rst
>   F:	include/linux/cpuset.h
>   F:	kernel/cgroup/cpuset.c
> +F:	tools/testing/selftests/cgroup/test_cpuset_prs.sh
>   
>   CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
>   M:	Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
> index e8bbbdb77e0d..0340d4ca8f51 100644
> --- a/tools/testing/selftests/cgroup/cgroup_util.c
> +++ b/tools/testing/selftests/cgroup/cgroup_util.c
> @@ -286,6 +286,8 @@ int cg_destroy(const char *cgroup)
>   {
>   	int ret;
>   
> +	if (!cgroup)
> +		return 0;
>   retry:
>   	ret = rmdir(cgroup);
>   	if (ret && errno == EBUSY) {
> diff --git a/tools/testing/selftests/cgroup/cgroup_util.h b/tools/testing/selftests/cgroup/cgroup_util.h
> index c92df4e5d395..1df7f202214a 100644
> --- a/tools/testing/selftests/cgroup/cgroup_util.h
> +++ b/tools/testing/selftests/cgroup/cgroup_util.h
> @@ -11,6 +11,8 @@
>   #define USEC_PER_SEC	1000000L
>   #define NSEC_PER_SEC	1000000000L
>   
> +#define TEST_UID	65534 /* usually nobody, any !root is fine */
> +
>   /*
>    * Checks if two given values differ by less than err% of their sum.
>    */
> diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
> index 600123503063..80aa6b2373b9 100644
> --- a/tools/testing/selftests/cgroup/test_core.c
> +++ b/tools/testing/selftests/cgroup/test_core.c
> @@ -683,7 +683,7 @@ static int test_cgcore_thread_migration(const char *root)
>    */
>   static int test_cgcore_lesser_euid_open(const char *root)
>   {
> -	const uid_t test_euid = 65534;	/* usually nobody, any !root is fine */
> +	const uid_t test_euid = TEST_UID;
>   	int ret = KSFT_FAIL;
>   	char *cg_test_a = NULL, *cg_test_b = NULL;
>   	char *cg_test_a_procs = NULL, *cg_test_b_procs = NULL;
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 2b5215cc599f..4afb132e4e4f 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -10,7 +10,7 @@
>   skip_test() {
>   	echo "$1"
>   	echo "Test SKIPPED"
> -	exit 0
> +	exit 4 # ksft_skip
>   }
>   
>   [[ $(id -u) -eq 0 ]] || skip_test "Test must be run as root!"
Reviewed-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

