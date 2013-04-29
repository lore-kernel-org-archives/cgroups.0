From: Colin Cross <ccross@android.com>
Subject: Re: [PATCH 02/10] freezer: skip waking up tasks with PF_FREEZER_SKIP set
Date: Mon, 29 Apr 2013 15:02:19 -0700
Message-ID: <CAMbhsRQHkm=XTYtummEZq1h4sa-tRGwLpk8Uyhpj9D3+jQF3dg@mail.gmail.com>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
	<1367271946-7239-3-git-send-email-ccross@android.com>
	<20130429215157.GA2395@htj.dyndns.org>
	<20130429215745.GB2395@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-pm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=R9cyTHswLKFpeZdfNm6f3lacErPDzkUij2S/C25qmEE=;
        b=N01H95AUqLjbuAnC+Dqv8qCQMCAcHUHLqVktEp0yg3UIlmY+a1mdQr1joIuAYQiQvZ
         7GE2W7/dOSXmqlcZ9sI0nIuVIJSj6wxXanzE+iIK8YmA4X5U8g1X7pcdRRd9FkUQC3re
         Nz+Wrn8uaq9DCZOQSPomnyTWF22z2RXScdkD5mmB1SEqxQKhWBxFJu6U9VbmsZYJpCrN
         YnJ34vTiid4i82oWDqANjTR9w4+TcujSCzlyFG69pOjzkDtbbH2uJUjCvU4oo6jSxcvI
         fnaokSzwhXSq3DsyX5i6UlqjkjBx+5EUx9Y3XUuDM6o18nubzRS2B/3KbptU7bkeOIiO
         7XDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20120917;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=R9cyTHswLKFpeZdfNm6f3lacErPDzkUij2S/C25qmEE=;
        b=Yr7C+yjSbTH9sQQTOwO6JlTIdIu1xt5XhC1QKsXwQFs9tovxRbFfGeyg+7l4v/PfZH
         RAe4wEEZJyUjxMicXdTHpZwhUt1RsnJa/D+v1EbQCOfHJyoKUp19RJo+N10gJdLabLP7
         KfX1pXEN70jf9HFe+xA8rzKtGt8QVkfndtq9ziun4VqKOOIcde52F5nrqnq30dVNn0ca
         2hWUK7AvlArYUTxO+9sITZz6pO4MuEKiDT/1ZKcKKWELXAr/XwoeIa1O62rS+djPD9u1
         Aof2Ptj+agF7c+DQEQ7cYct+LZ1EP/0+niYE5Eh3oX/FmUEf06JLGJ0nBILossj1wBzg
         hhDw==
In-Reply-To: <20130429215745.GB2395@htj.dyndns.org>
Sender: linux-pm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>, Li Zefan <lizefan@huawei.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, containers@lists.linux-foundation.org, cgroups@vger.kernel.org

On Mon, Apr 29, 2013 at 2:57 PM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Apr 29, 2013 at 02:51:57PM -0700, Tejun Heo wrote:
>> I feel a bit weary of changes which try to optimize state checks for
>> freezer because the synchronization rules are kinda fragile and things
>> may not work reliably depending on who's testing the flag, and it has
>> been subtly broken in various ways in the past (maybe even now).  Can
>
> And BTW, this is why the function is only used when checking whether a
> task is frozen rather than to decide to issue freeze_task() on it, and
> it seems your change is correct now that we don't have per-task FREEZE
> flag but I can't say I like the change.  I'd really like to keep
> things as dumb as possible for freezer.

See the first patch in the series (which isn't available in the
archive yet, so I can't link to it).  The short version is that
Android goes through suspend/resume very often (every few seconds when
on a busy wifi network with the screen off), and a significant portion
of the energy used to go in and out of suspend is spent in the
freezer.  This patch series takes the most common userspace sleep
points and converts them to PF_FREEZER_SKIP, which reduces the number
of context switches for every suspend or resume event on a
freshly-booted Android device from 1000 to 25, and reduces the time
spent freezing by a factor of 5.  It will have a similar effect on a
non-Android system, although those generally don't care about
suspend/resume optimization.
