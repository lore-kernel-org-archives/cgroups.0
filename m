From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Mon, 2 Mar 2015 08:49:26 -0500
Message-ID: <20150302134926.GA17694@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org>
 <54F09E62.8000007@gmail.com>
 <20150227170640.GK3964@htj.duckdns.org>
 <54F0BC51.4050506@gmail.com>
 <CAOviyajSOY6kTiwTA+APf9VGT=Ui=0QQH6KUqwaxHB3ahuJk2g@mail.gmail.com>
 <20150228115926.GA1005@htj.duckdns.org>
 <CAAAKZws45c3PhFQMGrm_K+OZV+KOyGV9sXTakHcTfNP1kHxzOQ@mail.gmail.com>
 <20150228164353.GR3964@htj.duckdns.org>
 <54F461F3.3030903@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jqQ2/Gq2tlqy1QUcKqcaqi+0NmuJx57vnaL/w+aoWWQ=;
        b=W+g090H93snTdJOFFgEI2R3dHAxn1wKtRO4fEDeTri55UDqzdg6kaKEnBTJvmuvANt
         RU+69oUyBijN8iSMQhEWUC6rIOPveolXVxBvqk0kJfJgtkymmhmywg0iu2GX9og/I1e2
         k9pTqxTuaD8+hhf6pUc/viZoixsjWkKahtP/z6yZyl7JynGKaCfxCZzdDnU+A8zd/zbn
         0506/psYp1tNURtvL1NuqQnmQcSBSfJDcCb8UPjJ1kzWYhrA5kU8wbr4MMr1NAfJjf+J
         b5S+EgATxbbozYXP0TCSwPbYphN2pnUrmUvG7lowN/cpe1ZfuGfA7zqdrY03NUhdX95C
         oUgg==
Content-Disposition: inline
In-Reply-To: <54F461F3.3030903@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Tim Hockin <thockin@hockin.org>, Frederic Weisbecker <fweisbec@gmail.com>, lizefan@huawei.com, richard@nod.at, mingo@redhat.com, Aleksa Sarai <cyphar@cyphar.com>, cgroups@vger.kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org

On Mon, Mar 02, 2015 at 08:13:23AM -0500, Austin S Hemmelgarn wrote:
> If 16-bit PID's aren't a concern anymore, then why do we still default to
> treating it like a 16-bit signed int (the default for
> /proc/sys/kernel/pid_max is 32768)?

Inertia.  It has to start there for backward compatibility.  Now it's
trivial to adjust dynamically and majority of the users don't need to
worry about it, so there's no pressing reason to bump it up by
default.

16bit pid_t was already a dying breed on 32bit config and it never was
an option on 64bit.  Any remotely modern distros in the past decade,
whether 32 or 64bit, wouldn't have any problem with it.  The only
possibly problematic case would be legacy code which for some reason
explicitly used 16bit integer types instead of pid_t, but at this
point, we shouldn't be basing any design decisions on that.  If
anybody is still depending on that, there are different ways ton deal
with the issue on their end including namespacing its pid space.

Thanks.

-- 
tejun
