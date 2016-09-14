From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [RFC v3 03/22] bpf,landlock: Add a new arraymap type to deal
 with (Landlock) handles
Date: Wed, 14 Sep 2016 11:51:58 -0700
Message-ID: <20160914185157.GA53542@ast-mbp.thefacebook.com>
References: <20160914072415.26021-1-mic@digikod.net>
 <20160914072415.26021-4-mic@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=DWr9oT85ssUULak/YRRQblpnBTy9E0OmaakFbDkSERg=;
        b=XnvC3hQstPRd1M3H7TYT7/aMG+Fo9HXAXexK6Rub3Q61SA2oqNLn0kEsAiYVZbhyZR
         Pa1s3xAMrx34T42OdSwpVIWdiGEqlEVFTAqtuOLLGjV4kPHG/AhWfZTrwFFlSVIpP+AR
         U/yrTNckViJRzGdR0PkKXhmzcD+DPcow3zfj8LCEIlDV/ZUojhRfltzS+3ZUWm51cyQ6
         mgHbrMQWqwDem8xI/pvLvNf8zolB1g07Li7HqmEKnyqvmdQ2cBhPewTDw9WtYlYzGfA/
         i91Cu5edpbZNqK4RsUbUvYG8O+0dkX+C6i/4BZzvENHPIXJBkk9oj4OJBeN87NlX/+/u
         LN/A==
Content-Disposition: inline
In-Reply-To: <20160914072415.26021-4-mic@digikod.net>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kern

On Wed, Sep 14, 2016 at 09:23:56AM +0200, Micka=EBl Sala=FCn wrote:
> This new arraymap looks like a set and brings new properties:
> * strong typing of entries: the eBPF functions get the array type of
>   elements instead of CONST_PTR_TO_MAP (e.g.
>   CONST_PTR_TO_LANDLOCK_HANDLE_FS);
> * force sequential filling (i.e. replace or append-only update), which
>   allow quick browsing of all entries.
>=20
> This strong typing is useful to statically check if the content of a map
> can be passed to an eBPF function. For example, Landlock use it to store
> and manage kernel objects (e.g. struct file) instead of dealing with
> userland raw data. This improve efficiency and ensure that an eBPF
> program can only call functions with the right high-level arguments.
>=20
> The enum bpf_map_handle_type list low-level types (e.g.
> BPF_MAP_HANDLE_TYPE_LANDLOCK_FS_FD) which are identified when
> updating a map entry (handle). This handle types are used to infer a
> high-level arraymap type which are listed in enum bpf_map_array_type
> (e.g. BPF_MAP_ARRAY_TYPE_LANDLOCK_FS).
>=20
> For now, this new arraymap is only used by Landlock LSM (cf. next
> commits) but it could be useful for other needs.
>=20
> Changes since v2:
> * add a RLIMIT_NOFILE-based limit to the maximum number of arraymap
>   handle entries (suggested by Andy Lutomirski)
> * remove useless checks
>=20
> Changes since v1:
> * arraymap of handles replace custom checker groups
> * simpler userland API
>=20
> Signed-off-by: Micka=EBl Sala=FCn <mic@digikod.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Kees Cook <keescook@chromium.org>
> Link: https://lkml.kernel.org/r/CALCETrWwTiz3kZTkEgOW24-DvhQq6LftwEXh77FD=
2G5o71yD7g@mail.gmail.com
> ---
>  include/linux/bpf.h      |  14 ++++
>  include/uapi/linux/bpf.h |  18 +++++
>  kernel/bpf/arraymap.c    | 203 +++++++++++++++++++++++++++++++++++++++++=
++++++
>  kernel/bpf/verifier.c    |  12 ++-
>  4 files changed, 246 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index fa9a988400d9..eae4ce4542c1 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -13,6 +13,10 @@
>  #include <linux/percpu.h>
>  #include <linux/err.h>
> =20
> +#ifdef CONFIG_SECURITY_LANDLOCK
> +#include <linux/fs.h> /* struct file */
> +#endif /* CONFIG_SECURITY_LANDLOCK */
> +
>  struct perf_event;
>  struct bpf_map;
> =20
> @@ -38,6 +42,7 @@ struct bpf_map_ops {
>  struct bpf_map {
>  	atomic_t refcnt;
>  	enum bpf_map_type map_type;
> +	enum bpf_map_array_type map_array_type;
>  	u32 key_size;
>  	u32 value_size;
>  	u32 max_entries;
> @@ -187,6 +192,9 @@ struct bpf_array {
>  	 */
>  	enum bpf_prog_type owner_prog_type;
>  	bool owner_jited;
> +#ifdef CONFIG_SECURITY_LANDLOCK
> +	u32 n_entries;	/* number of entries in a handle array */
> +#endif /* CONFIG_SECURITY_LANDLOCK */
>  	union {
>  		char value[0] __aligned(8);
>  		void *ptrs[0] __aligned(8);
> @@ -194,6 +202,12 @@ struct bpf_array {
>  	};
>  };
> =20
> +#ifdef CONFIG_SECURITY_LANDLOCK
> +struct map_landlock_handle {
> +	u32 type; /* enum bpf_map_handle_type */
> +};
> +#endif /* CONFIG_SECURITY_LANDLOCK */
> +
>  #define MAX_TAIL_CALL_CNT 32
> =20
>  struct bpf_event_entry {
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 7cd36166f9b7..b68de57f7ab8 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -87,6 +87,15 @@ enum bpf_map_type {
>  	BPF_MAP_TYPE_PERCPU_ARRAY,
>  	BPF_MAP_TYPE_STACK_TRACE,P_TYPE_CGROUP_ARRAY
>  	BPF_MAP_TYPE_CGROUP_ARRAY,
> +	BPF_MAP_TYPE_LANDLOCK_ARRAY,
> +};
> +
> +enum bpf_map_array_type {
> +	BPF_MAP_ARRAY_TYPE_UNSPEC,
> +};
> +
> +enum bpf_map_handle_type {
> +	BPF_MAP_HANDLE_TYPE_UNSPEC,
>  };

missing something. why it has to be special to have it's own
fd array implementation?
Please take a look how BPF_MAP_TYPE_PERF_EVENT_ARRAY,=20
BPF_MAP_TYPE_CGROUP_ARRAY and BPF_MAP_TYPE_PROG_ARRAY are done.
The all store objects into array map that user space passes via FD.
I think the same model should apply here.

--
To unsubscribe from this list: send the line "unsubscribe linux-security-mo=
dule" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
