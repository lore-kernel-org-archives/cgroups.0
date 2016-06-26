From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Sun, 26 Jun 2016 18:26:17 -0400
Message-ID: <CAOS58YMxz5HfJUayqjw+SPj485M+wquTqQouk367rV2mfvVRHg@mail.gmail.com>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
 <20160623213819.GP3262@mtj.duckdns.org> <53377cda-9afe-dad4-6bbb-26affd64cb3a@gmail.com>
 <20160624154830.GX3262@mtj.duckdns.org> <20160624155916.GA8759@mail.hallyn.com>
 <20160624163527.GZ3262@mtj.duckdns.org> <20160624165910.GA9675@mail.hallyn.com>
 <20160624172447.GA3262@mtj.duckdns.org> <47890d79-0891-dd13-4f60-e7e5f1f3fed3@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=bRaVySIkeWoeCHqoC9ovKsRpZfrosF2yj3A47IFoaVM=;
        b=if6MTKikE/TdHo7G3dLBzHKAdZI9yzl3xvRPtWlPaOAzYMB/nzM5JUHYWYVAen8vu7
         vwMb6vOFgS0GexgLPWbYF8MQ44OMJEVC1n9rrM+sHjiOUHlwQMvoK59mHUbTCbNzuSDH
         xAGrPcdcUSdiLIojIKzRZyPp7SCKazW8XNzCj+pZq9ZK446yJVKlS45Uxw23uOZn+U1r
         m9hxvmotthqSNyKN61PbJrWkHat+7BUdUCsENpNbRqhFlBmVrp2WydTDQ6HuNtv8dxxM
         yjfNB6PANm0g27dKKY0T01vM9IpBIL4xrHpKtZQjPk8mXdrAClaPtwkboceC8KQjkoOW
         jsYw==
In-Reply-To: <47890d79-0891-dd13-4f60-e7e5f1f3fed3@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, lkml <linux-kernel@vger.kernel.org>, luto@kernel.org, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

Hello, Topi.

On Sun, Jun 26, 2016 at 3:14 PM, Topi Miettinen <toiwoton@gmail.com> wrote:
> The parent might be able do it if proc/pid/xyz files are still
> accessible after child exit but before its exit status is collected. But
> if the parent doesn't do it (and you are not able to change it to do it)
> and it collects the exit status without collecting other info, can you
> suggest a different way how another process could collect it 100% reliably?

I'm not saying that there's such mechanism now. I'm suggesting that
that'd be a more fitting way of implementing a new mechanism to track
capability usages.

Thanks.

-- 
tejun
