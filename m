From: Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC PATCH v1 1/4] cgroup quota: add disk space parse strategy
 to res_counter
Date: Sun, 11 Mar 2012 15:19:22 +0400
Message-ID: <4F5C8A3A.7080601@parallels.com>
References: <4F59E799.6030409@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4F59E799.6030409@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: jeff.liu@oracle.com
Cc: cgroups@vger.kernel.org, lxc-devel@lists.sourceforge.net, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com, tj@kernel.org, Li Zefan <lizf@cn.fujitsu.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>, Christopher Jones <christopher.jones@oracle.com>, Dave Chinner <david@fromorbit.com>, jack@suse.cz, tytso@MIT.EDU

On 03/09/2012 03:20 PM, Jeff Liu wrote:
> Introduce a new disk space parse strategy routine for cgroup quota supports.
> disk_space_parse() is simply copied from mmparse() with Petabytes and Terabytes parse.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> ---
>   include/linux/res_counter.h |    3 ++
>   kernel/res_counter.c        |   58 +++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 61 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> index c9d625c..f8ce315 100644
> --- a/include/linux/res_counter.h
> +++ b/include/linux/res_counter.h
> @@ -79,6 +79,9 @@ typedef int (*write_strategy_fn)(const char *buf, unsigned long long *val);
>   int res_counter_memparse_write_strategy(const char *buf,
>   					unsigned long long *res);
>
> +int res_counter_diskspace_parse_write_strategy(const char *buf,
> +					       unsigned long long *res);
> +
>   int res_counter_write(struct res_counter *counter, int member,
>   		      const char *buffer, write_strategy_fn write_strategy);
>
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 34683ef..42c1623 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -145,6 +145,64 @@ u64 res_counter_read_u64(struct res_counter *counter, int member)
>   }
>   #endif
>
> +/*
> + * Copy from memparse(), add terabytes, petabytes parse support.
> + */
Don't see a reason for that. It is all bytes and such, just add the 
modifiers you want to the normal parse...

> +unsigned long long disk_space_parse(const char *ptr, char **retptr)
> +{
> +	char *endptr; /* local pointer to end of parsed string */
> +	unsigned long long ret = kstrtoull(ptr,&endptr, 0);
> +
> +	switch (*endptr) {
> +	case 'P':
> +	case 'p':
> +		ret<<= 10;
> +	case 'T':
> +	case 't':
> +		ret<<= 10;
> +	case 'G':
> +	case 'g':
> +		ret<<= 10;
> +	case 'M':
> +	case 'm':
> +		ret<<= 10;
> +	case 'K':
> +	case 'k':
> +		ret<<= 10;
> +		endptr++;
> +	default:
> +		break;
> +	}
> +
> +	if (retptr)
> +		*retptr = endptr;
> +
> +	return ret;
> +}
> +
> +int res_counter_diskspace_parse_write_strategy(const char *buf,
> +					       unsigned long long *res)
> +{
> +	char *end;
> +
> +	/* return RESOURCE_MAX(unlimited) if "-1" is specified */
> +	if (*buf == '-') {
> +		*res = kstrtoull(buf + 1,&end, 10);
> +		if (*res != 1 || *end != '\0')
> +			return -EINVAL;
> +		*res = RESOURCE_MAX;
> +		return 0;
> +	}
> +
> +	/* FIXME - make memparse() take const char* args */
> +	*res = disk_space_parse((char *)buf,&end);
> +	if (*end != '\0')
> +		return -EINVAL;
> +
> +	/* FIXME - need to return *res as block aligned? */
> +	return 0;
> +}
> +
>   int res_counter_memparse_write_strategy(const char *buf,
>   					unsigned long long *res)
>   {

