From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC v3 19/22] landlock: Add interrupted origin
Date: Wed, 14 Sep 2016 11:29:28 -0700
Message-ID: <CALCETrUyqZEcJansuN=NX04CXv4ROtNqB25YZw7mBGuu43DFew@mail.gmail.com>
References: <20160914072415.26021-1-mic@digikod.net> <20160914072415.26021-20-mic@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IBh360yOASSo/Ap1uKafLBuRgnqMAkHwoB/jL/77Vkw=;
        b=1KBzrYp+iboWeOmoxYPpInGPvtnB44Mx5r4Q3uHI+JQ56aqZDh2B9829elDtOJSVGM
         j4xswam2mjkMxSGIEVLQd9aBrkG3E4bIpXcnwJhUFpgxA2BsObhSPIoCW8XQpBhgtj6a
         H6zLQopgN7+AsOjNjweRd6I9kJi82fNQveVWhT6a+6M1xu0YJJx1BKX3E8LVSmPFwngS
         LgetoPynjwhpv9c9wieZl22x9ckAYGgIt0qSNg9ssvqvZbrAi8c4Jf97x4zop/TJiY8j
         o5nXhQfYUG5+dSqMNi7npMK2JRlWmIgVUg6yRESUyrfY3QezK1LRz810oc1bZNuYAufq
         GNQA==
In-Reply-To: <20160914072415.26021-20-mic@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, Will Drewry <wad@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux API <linu>

On Wed, Sep 14, 2016 at 12:24 AM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net=
> wrote:
> This third origin of hook call should cover all possible trigger paths
> (e.g. page fault). Landlock eBPF programs can then take decisions
> accordingly.
>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Kees Cook <keescook@chromium.org>
> ---


>
> +       if (unlikely(in_interrupt())) {

IMO security hooks have no business being called from interrupts.
Aren't they all synchronous things done by tasks?  Interrupts are
driver things.

Are you trying to check for page faults and such?

--Andy
