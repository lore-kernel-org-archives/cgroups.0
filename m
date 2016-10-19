From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [RFC v3 05/22] bpf,landlock: Add eBPF program subtype and
 is_valid_subtype() verifier
Date: Wed, 19 Oct 2016 17:01:17 +0200
Message-ID: <20161019150117.GB22003@pox.localdomain>
References: <20160914072415.26021-1-mic@digikod.net>
 <20160914072415.26021-6-mic@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suug-ch.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=g/Ujb4s4j+qWYIr5IX7NTb81ToHzskK1FZ3kFqctt94=;
        b=pm9N+hJXn4xbXhLNj6sP1K3BRnIQIzciDeT1igIHbTa/l3y7co98Mgu/wgVx9Av6UQ
         NGwFBiwBh8KygcKvn5leuhwUaC3obdeFuij9K8U/Jls0xufQyUzDufUVU2+32969PfkG
         gpHYBEy044ZfXZjKTgrDl7mKUr9wAR0YyRNVLy7HzgvEn6YzeioJRK4ZKvBuVrj3Y8Wo
         Dd/NEMaug/o15f9vy4VUN4nEgvVI3W453y7P4Fdt38K2nB1ovwAHej5bKOhS9l0A5rEv
         58XNF/gzsibM+KwwzXxyun7gYP6uK0OIAU8dqFl7knp2PknUsQ4alFWBWgFPsfuy/GpH
         8h0Q==
Content-Disposition: inline
In-Reply-To: <20160914072415.26021-6-mic@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kern

On 09/14/16 at 09:23am, Micka=EBl Sala=FCn wrote:
> @@ -155,6 +163,7 @@ union bpf_attr {
>  		__u32		log_size;	/* size of user buffer */
>  		__aligned_u64	log_buf;	/* user supplied buffer */
>  		__u32		kern_version;	/* checked when prog_type=3Dkprobe */
> +		union bpf_prog_subtype prog_subtype;	/* checked when prog_type=3Dlandl=
ock */

The comment seems bogus, this is not landlock specific.
