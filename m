From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 3/3] misc_cgroup: remove error log to avoid log flood
Date: Fri, 10 Sep 2021 06:29:41 -1000
Message-ID: <YTuH9fULTx+pLuuH@slm.duckdns.org>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <86e89df640f2b4a65dd77bdbab8152fa8e8f5bf1.1631077837.git.brookxu@tencent.com>
 <20210909143720.GA14709@blackbody.suse.cz>
 <CAHVum0ffLr+MsF0O+yEWKcdpR0J0TQx6GdDxeZFZY7utZT8=KA@mail.gmail.com>
 <YTpY0G3+IJYmGbdd@blackbook>
 <478e986c-bc69-62b8-936e-5b075f9270b4@gmail.com>
 <20210910092310.GA18084@blackbody.suse.cz>
 <1679f995-5a6f-11b8-7870-54318db07d0d@gmail.com>
 <20210910153609.GC24156@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vdtqoZFv4MiNf9W0UtI32iEhVLYL/ZJOdc/dPw1DUT0=;
        b=mKUglSAtqg5FFG0aE6ZYZRsjNgt0zN0tJdYTnxtOekBzBANig0bDKYPzJjqZ0Ioqwy
         flmnTwEG7eZEPaY40itMixbnaOAaLFbT7ZyMgLWsgbL1nE4729lG466b5abBZaPFyLUW
         xPHNh7bpUKRokfImZI1EfpksGLzp6dCuKDpU/PFvUovJ8MqthjiQwoND5XpJ2N0YtX7g
         /ISPOBz/Ne+rFXxlUHPgFrS9n51wjpaFY2hNMYagYGYwzKWaHzyx76zm1UqJ0JVBVmie
         IDP/3qYSufIqwQMVphqqFW+Z3g4GOBG+p6KDF8r7+3XLI+rsYt1CCkOOECd5hvmGIWeR
         m6Mw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210910153609.GC24156@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: "brookxu.cn" <brookxu.cn@gmail.com>, Vipin Sharma <vipinsh@google.com>, lizefan.x@bytedance.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello,

On Fri, Sep 10, 2021 at 05:36:09PM +0200, Michal Koutn=FD wrote:
> If there's a limit on certain level with otherwise unconstrained cgroup
> structure below (a valid config too), the 'fail' counter would help
> determining what the affected cgroup is. Does that make sense to you?

While the desire to make the interface complete is understandable, I don't
think we need to go too far in that direction given that debugging these
configuration issues requires human intervention anyway and providing
overall information is often enough of aid especially for simple controllers
like misc/pid. So, let's stick to something consistent and simple even if
not complete and definitely not name them "fail" even if we add them.

Thanks.

--=20
tejun
