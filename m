From: Shayan Pooya <shayan@liveve.org>
Subject: Re: bug in memcg oom-killer results in a hung syscall in another
 process in the same cgroup
Date: Mon, 11 Jul 2016 11:33:19 -0700
Message-ID: <CABAubTjGhUXMeAnFgW8LGck1tgvtu12Zb9fx5BRhDWNjZ7SYLQ@mail.gmail.com>
References: <CABAubThf6gbi243BqYgoCjqRW36sXJuJ6e_8zAqzkYRiu0GVtQ@mail.gmail.com>
 <20160711064150.GB5284@dhcp22.suse.cz> <CABAubThHfngHTQW_AEuW71VCvLyD_9b5Z05tSud5bf8JKjuA9Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=liveve-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=NA2EM5w4RfjqaLvPPMG3mPqbD0nbFNV6Yt/HYg7hPW8=;
        b=1SKyh2cbZ5iMo+oLkascK43x/4uvPhhapkq1tHjiPuFUJyRmhULiHzVndd2nLGp9+V
         y47VHG/gRLaMwWCwHIN8Vcgp6JML3CEMipnM4gszH1YuqKXt6isVtv5U1cHFK2g8tXt2
         jfHt/3qgPThdEbBdOF03XCYG7G+UFHEVcCywqlDeEYnyJvMOa/icmbyJv3JVpqDQ6GqX
         KYg8leYn6mHEBJTGX/iciYvVa8jP0ksCLo3A2paGBFvbQbq2G/uqkghPvddWE2mjBWL/
         +rpVA52Ia9a7/kH3jZQpuOCT3j2C9CJM91ztyABt1wNvX1etjh5SViOueiU/EBHUF5OL
         lWZQ==
In-Reply-To: <CABAubThHfngHTQW_AEuW71VCvLyD_9b5Z05tSud5bf8JKjuA9Q@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: cgroups mailinglist <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org

>> Could you post the stack trace of the hung oom victim? Also could you
>> post the full kernel log?

With strace, when running 500 concurrent mem-hog tasks on the same
kernel, 33 of them failed with:

strace: ../sysdeps/nptl/fork.c:136: __libc_fork: Assertion
`THREAD_GETMEM (self, tid) != ppid' failed.

Which is: https://sourceware.org/bugzilla/show_bug.cgi?id=15392
And discussed before at: https://lkml.org/lkml/2015/2/6/470 but that
patch was not accepted.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
