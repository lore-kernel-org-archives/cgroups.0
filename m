From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH 3/3] misc_cgroup: remove error log to avoid log flood
Date: Fri, 10 Sep 2021 10:31:02 -0700
Message-ID: <CAHVum0e+68df7b_e0RoCGgA1h_SLdTt9t2MZ0VgA9afPW9iEvg@mail.gmail.com>
References: <86e89df640f2b4a65dd77bdbab8152fa8e8f5bf1.1631077837.git.brookxu@tencent.com>
 <20210909143720.GA14709@blackbody.suse.cz> <CAHVum0ffLr+MsF0O+yEWKcdpR0J0TQx6GdDxeZFZY7utZT8=KA@mail.gmail.com>
 <YTpY0G3+IJYmGbdd@blackbook> <478e986c-bc69-62b8-936e-5b075f9270b4@gmail.com>
 <20210910092310.GA18084@blackbody.suse.cz> <1679f995-5a6f-11b8-7870-54318db07d0d@gmail.com>
 <20210910153609.GC24156@blackbody.suse.cz> <YTuH9fULTx+pLuuH@slm.duckdns.org>
 <CAHVum0ezWW=4x2YgXHhEUFQOkFGBpP+R1Uc-KedHr+r0LGibwA@mail.gmail.com> <YTuTr5Hw4hPIWepd@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j4e2VGm4rZT+9uHWwvDnPkLTEAhTR8ODAxNvnYiGuQw=;
        b=S+FRcNht9+4Pr/NtV9V2YjE7h0FhQpqrIe5JtlAODhefHbazOjyRwvpQvlwmcyzu4g
         0sVjuV3fYVzTwn+rQjMjzlGV//VbtvsfgZsPGFB6IrGbHKKhMb+mybS7IO0v65yKcaRh
         TK+MwUWxI2g/bmAC5bWTKkply4ijnNYq9i7W/jEU498T5Iq+ayXfv0Aay5A4vADoCIB+
         TMskqhFeYtFPcFdU8c5ZCQHsJJMgtKUdvilz7xSoVnO6YOBSdgkKRcl2OkgXIVB+u0Vb
         c/EqFmNmYv6+mLrzlUongpTVBH3Qa+18Z56OxVXJw7zRt6clfU5eXBRB1t844WITPHlw
         Cphw==
In-Reply-To: <YTuTr5Hw4hPIWepd@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, "brookxu.cn" <brookxu.cn@gmail.com>, lizefan.x@bytedance.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Fri, Sep 10, 2021 at 10:19 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Fri, Sep 10, 2021 at 10:16:46AM -0700, Vipin Sharma wrote:
> > For now, I think we can just have one file, events.local
> > (non-hierarchical) which has %s.max type entries. This will tell us
> > which cgroup is under pressure and I believe this is helpful.
>
> How about just sticking with hierarchical events? Do you see a lot of
> downsides with that compared to .local?
>

Local would have made it easier to identify constrained cgroup and the
lesser number of file notify events will be fired.

I don't have a strong aversion to hierarchical events only as well if
that is more suited for the cgroup v2 style.
