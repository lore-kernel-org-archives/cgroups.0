From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [RFC v3 21/22] bpf,landlock: Add optional skb pointer in the
 Landlock context
Date: Wed, 14 Sep 2016 14:20:55 -0700
Message-ID: <20160914212054.GC57174@ast-mbp.thefacebook.com>
References: <20160914072415.26021-1-mic@digikod.net>
 <20160914072415.26021-22-mic@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=fYTLy1YGS8z+Z/zDy4dhY9s/axo4996xgNuqoi4Y0r8=;
        b=lmLUWTlG1tJU4PJH2hnOnMxH5tIDjc2nBXoG3xws7xikK9C/NrWmPJcziHH8nKvaio
         HB/KWuXqhXJpS/M+fSe1TglTcoXOYBqq78DhbWA+z+9nYb+lvv0s4853e8ydfjMGGJpk
         IkH+zgItcD9cL0BmhKsVqVTDuV/0x9JZjb2jNwOkvYCsALz2kX4MYQlmXyS3qi/0mj1p
         aLr8acsFkMsG/gYEwZOc46vTTgQ34U9uj0PbTBwXykw3SB3KAaJ71Ulc4UIUhiR/XaeY
         dCt+2Nlzlq2KLXT0Xrkfx5T67ORYJ9rnEepYAxkoPgj9QfcmNcvB2ogPlrOCx8j/RXeR
         8gKw==
Content-Disposition: inline
In-Reply-To: <20160914072415.26021-22-mic@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kern

On Wed, Sep 14, 2016 at 09:24:14AM +0200, Micka=EBl Sala=FCn wrote:
> This is a proof of concept to expose optional values that could depend
> of the process access rights.
>=20
> There is two dedicated flags: LANDLOCK_FLAG_ACCESS_SKB_READ and
> LANDLOCK_FLAG_ACCESS_SKB_WRITE. Each of them can be activated to access
> eBPF functions manipulating a skb in a read or write way.
>=20
> Signed-off-by: Micka=EBl Sala=FCn <mic@digikod.net>
...
>  /* Handle check flags */
>  #define LANDLOCK_FLAG_FS_DENTRY		(1 << 0)
> @@ -619,12 +621,15 @@ struct landlock_handle {
>   * @args: LSM hook arguments, see include/linux/lsm_hooks.h for there
>   *        description and the LANDLOCK_HOOK* definitions from
>   *        security/landlock/lsm.c for their types.
> + * @opt_skb: optional skb pointer, accessible with the
> + *           LANDLOCK_FLAG_ACCESS_SKB_* flags for network-related hooks.
>   */
>  struct landlock_data {
>  	__u32 hook; /* enum landlock_hook_id */
>  	__u16 origin; /* LANDLOCK_FLAG_ORIGIN_* */
>  	__u16 cookie; /* seccomp RET_LANDLOCK */
>  	__u64 args[6];
> +	__u64 opt_skb;
>  };

missing something here.
This patch doesn't make use of it.
That's something for the future?
How that field will be populated?
Why make it different vs the rest or args[6] ?

