From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 01/12] kernfs: add function to find kernfs_node without
 increasing ref counter
Date: Tue, 13 Nov 2018 18:53:59 +0100
Message-ID: <07A5F685-9D7D-42A7-9A10-73C658F47435@linaro.org>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
 <20181112095632.69114-2-paolo.valente@linaro.org>
 <20181112122840.GA1429@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/UQjNl9KMYOO2L/Btjnus7YePUZ4dnRxDDZ4QOFJ+4Q=;
        b=RwoGukJJ7K/gZSt1+7JVUvI3S4b7QqodpFcNlk4KWLoTAHsfD+7zFrfMXBRT2KUp59
         gmmc8Mwn2I91WRjCnL5QxXqgapAXgG9n+I5bljScvf4yFYSXXn7GxZIf4pJWI4rj60Gu
         CikS/N9nWD+xRVUir63QNA8LGtTC6vAjqY2M0=
In-Reply-To: <20181112122840.GA1429@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>



> Il giorno 12 nov 2018, alle ore 13:28, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> ha scritto:
>=20
> On Mon, Nov 12, 2018 at 10:56:21AM +0100, Paolo Valente wrote:
>> From: Angelo Ruocco <angeloruocco90@gmail.com>
>>=20
>> The kernfs pseudo file system doesn't export any function to only =
find
>> a node by name, without also getting a reference on it.
>> But in some cases it is useful to just locate a kernfs node, while
>> using it or not depends on some other condition.
>>=20
>> This commit adds a function to just look for a node, without getting
>> a reference on it.
>=20
> Eeek, that sounds really bad.  So you save off a pointer to something,
> and have no idea if that pointer now really is valid or not?  It can
> instantly disappear right afterwards.
>=20

Hi Greg,
that function is invoked only in functions executed with cgroup_mutex
held.  This guarantees that nothing disappears or becomes
inconsistent.  That's why we decided to go for this optimization,
instead of doing useless gets&puts pairs.  Still, I'm not expert
enough to state whether it is impossible that, once we have defined
that function, it may then get used in some unsafe way.

So, I seem to see two options:
1) Add a comment on the function, saying that cgroup_mutex must be
   held while invoking it (I guess you won't like this one).
2) Do not define such a new function, and, in the other patches, use
   the already-available find_and_get.

Looking forward to your feedback (or of other knowledgeable people on
this issue) before proceeding to a rebased V2,
Paolo


> This feels wrong, what is the problem of having a properly reference
> counted object passed back to you that you have to create a dangerous
> function like this?
>=20
> greg k-h

