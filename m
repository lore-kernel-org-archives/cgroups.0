From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 09/10] landlock: Handle cgroups
Date: Fri, 26 Aug 2016 08:55:12 -0400
Message-ID: <20160826125512.GC16906@mtj.duckdns.org>
References: <1472121165-29071-1-git-send-email-mic@digikod.net>
 <1472121165-29071-10-git-send-email-mic@digikod.net>
 <CALCETrVqfTaY4gfwNdwynBqWwYh6xsGHaqdoA3uc_jHogbkA-A@mail.gmail.com>
 <57BF043D.4000300@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=IQOA3D3emxM6Ap9M232BNLkGMGuBiCLEzIPxRAEBUoE=;
        b=atHcBsJchHCCsh9EW0EtbVi83N+IXfVB6QzExhkEw7CIKBW1VbjtPCkQbu7UNBmBnL
         EslkkRTjBCN6CVOLYZZYNycQmp8sIN+sWdiwFtXMV/DyLoX1pBgaUalZ4lCDRVwq9ubD
         wVmEN0QU+LyRWC0N9lHsMzqNkqjydoBG41Z0MWSqXe6ln7FX0Ih1CAROcxY5GcAs3elX
         QQzaAW1vJJDlHnd6esDESXtrTnE7XIzU6pNxvzFsDRvm/NF+ZSndVBwGY1hQ5u7X8m2c
         gfLEtzy3ap00/PJa81693dIfiZqI+ZOEOXRKSvxysAdWuhD9mpDojFAqTqBwQkv6og6Z
         XrUQ==
Content-Disposition: inline
In-Reply-To: <57BF043D.4000300@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Andy Lutomirski <luto@amacapital.net>, LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Will Drewry <wad@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>

Hello,

On Thu, Aug 25, 2016 at 04:44:13PM +0200, Micka=EBl Sala=FCn wrote:
> I tested with cgroup-v2 but indeed, it seems a bit different with
> cgroup-v1 :)
> Does anyone know how to handle both cases?

If you wanna do cgroup membership test, just do cgroup v2 membership
test.  No need to introduce a new controller and possibly struct sock
association field for that.  That's what all new cgroup aware network
operations are using anyway and doesn't conflicts with whether other
controllers are v1 or v2.

For examples of using cgroup v2 membership test, please take a look at
cgroup_mt_v1().

Thanks.

--=20
tejun
