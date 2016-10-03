From: Kees Cook <keescook@chromium.org>
Subject: Re: [RFC v3 19/22] landlock: Add interrupted origin
Date: Mon, 3 Oct 2016 16:46:26 -0700
Message-ID: <CAGXu5j+90zJTcfm2DMP04zu0pg832dKgSJgfFYxLVvV=CZk16g@mail.gmail.com>
References: <20160914072415.26021-1-mic@digikod.net> <20160914072415.26021-20-mic@digikod.net>
 <CALCETrUyqZEcJansuN=NX04CXv4ROtNqB25YZw7mBGuu43DFew@mail.gmail.com>
 <57D9CBD3.7030100@digikod.net> <CALCETrWmp33g0_adWcLXLuQe7R2EeLchKGivQnEsK5A4nAwTfw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=M04FstruEeQvvEis/leMMHu9eEUcBC+M6eXXDikW38U=;
        b=P0iddo4pnxTcGq10O/h1nFcZnftC6soltAn7N6/ObA71VkQeYnAtthvb3Vwe+tVWFM
         jeIgoWxxQFD02fWm3RzXjPOfIzK+HkK5tVYNpQKHsspb4k1HiykT3v5PmaY5nQFtf1Pb
         e/SaJ4ZYqQT1lpbe/1zG4W7KzcTj4wKX6ZbG+ovyRdjXoHeo28mGSaVjld07k+uPpyxa
         2LOJJ2kRMZjMSLZrUL5+He+Bm0mTkQdfq1igaTJ6Rn4iIfU+9wVayivBmJ3I1rv3nb5C
         fUVEo9/QtbrjM1Jaj7BKDRrFyXmqfe1aknNkd4eGtB2GfKgrQ2lU8sBm+i/blZ4287Xp
         0/pw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=M04FstruEeQvvEis/leMMHu9eEUcBC+M6eXXDikW38U=;
        b=hOWdH/+4v8piUJnSJ7Q1iYqeZL+AGcvlDI8i1WZv/Pw02Y045rmagokBFeTGk52YK1
         E2hLgEeIp6kdPJNsJFs2aTKZOKMRckAM8o4/4ZIwHXLW6/QN45XBHZAOmD4yxe603vn6
         xN2VqoO/Nfw2EP/FYEZPjnpQ2eUVePc4z0eE4=
In-Reply-To: <CALCETrWmp33g0_adWcLXLuQe7R2EeLchKGivQnEsK5A4nAwTfw@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Andy Lutomirski <luto@amacapital.net>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, Will Drewry <wad@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>

On Wed, Sep 14, 2016 at 6:19 PM, Andy Lutomirski <luto@amacapital.net> wrot=
e:
> On Wed, Sep 14, 2016 at 3:14 PM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.ne=
t> wrote:
>>
>> On 14/09/2016 20:29, Andy Lutomirski wrote:
>>> On Wed, Sep 14, 2016 at 12:24 AM, Micka=C3=ABl Sala=C3=BCn <mic@digikod=
.net> wrote:
>>>> This third origin of hook call should cover all possible trigger paths
>>>> (e.g. page fault). Landlock eBPF programs can then take decisions
>>>> accordingly.
>>>>
>>>> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>>>> Cc: Alexei Starovoitov <ast@kernel.org>
>>>> Cc: Andy Lutomirski <luto@amacapital.net>
>>>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>>>> Cc: Kees Cook <keescook@chromium.org>
>>>> ---
>>>
>>>
>>>>
>>>> +       if (unlikely(in_interrupt())) {
>>>
>>> IMO security hooks have no business being called from interrupts.
>>> Aren't they all synchronous things done by tasks?  Interrupts are
>>> driver things.
>>>
>>> Are you trying to check for page faults and such?
>>
>> Yes, that was the idea you did put in my mind. Not sure how to deal with
>> this.
>>
>
> It's not so easy, unfortunately.  The easiest reliable way might be to
> set a TS_ flag on all syscall entries when TIF_SECCOMP or similar is
> set.

For making this series smaller, let's leave the idea idea of interrupt
hooks out -- the intention is for stricter syscall filtering, yes?

Once things are more well established and there's a use-case for this,
it can be added back in.

-Kees


--=20
Kees Cook
Nexus Security
