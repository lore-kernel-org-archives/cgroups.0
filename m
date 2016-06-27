From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Mon, 27 Jun 2016 15:17:45 -0400
Message-ID: <CAOS58YM+h0w_UciXLbiJcKizPkXV66FL57LT7Mc+RRWspN+Y2Q@mail.gmail.com>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
 <20160623213819.GP3262@mtj.duckdns.org> <53377cda-9afe-dad4-6bbb-26affd64cb3a@gmail.com>
 <20160624154830.GX3262@mtj.duckdns.org> <20160624155916.GA8759@mail.hallyn.com>
 <20160624163527.GZ3262@mtj.duckdns.org> <20160624165910.GA9675@mail.hallyn.com>
 <20160624172447.GA3262@mtj.duckdns.org> <47890d79-0891-dd13-4f60-e7e5f1f3fed3@gmail.com>
 <CAOS58YMxz5HfJUayqjw+SPj485M+wquTqQouk367rV2mfvVRHg@mail.gmail.com>
 <20160627145457.GA26980@mail.hallyn.com> <58938c8b-aca6-a5b8-9533-58e78d878e85@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=WMCUpGJPk5ldJwrr3rHSIt1Gm2xzStdIvomiWkvUBqI=;
        b=zcPdifUpZxykpFcezsTjjDZne817AvHg2nUYXauhHP2dJVzU1aD8y+raWXXYKC9uC8
         eTCPXUc4KtG5Fn9HQlx7+gNeXsItwoCujv+5VOojXC5RYI7O00rLtFxyy8eHJHay7tZm
         lBkQsGITfjYGDo9Yy4vjAWR+NwZ/owR2jqj2qC2id7TzABNmXTc58ANOZLyC4f/Vh4jC
         HuN3nfmcChVj9SATbq53WRnUcpWK4Pvmc/pqIE0KCZCFnJreQTJSZGUq+6JjaDTL9oVz
         IukZCW56cCcZTCUNkNu3yd+x4AyoNooOg3xAabfQ7t168tuSwiBktpwxbiS2GscycUS8
         itsQ==
In-Reply-To: <58938c8b-aca6-a5b8-9533-58e78d878e85@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, lkml <linux-kernel@vger.kernel.org>, luto@kernel.org, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

Hello,

On Mon, Jun 27, 2016 at 3:10 PM, Topi Miettinen <toiwoton@gmail.com> wrote:
> I'll have to study these more. But from what I saw so far, it looks to
> me that a separate tool would be needed to read taskstats and if that
> tool is not taken by distros, the users would not be any wiser, right?
> With cgroup (or /proc), no new tools would be needed.

That is a factor but shouldn't be a deciding factor in designing our
user-facing interfaces. Please also note that kernel source tree
already has tools/ subdirectory which contains userland tools which
are distributed along with the kernel.

Thanks.

-- 
tejun
