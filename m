From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/4] cgroup bpf auto-detachment
Date: Tue, 28 May 2019 09:34:40 -0700
Message-ID: <CAADnVQJ7DpjeyAu28qtYymXxcWBa5SGxvW-JOTWyY-gJ6gmX9A@mail.gmail.com>
References: <20190525163742.2616471-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1myZtded1RLBPOtfFMrOo9NJSxPtLPt4RXZAdQZ1vIU=;
        b=IE8ur7agfZBBCR5CIL7GjM8g8jWr7z/JqzqNUZX8/3off9XT23B7JKi8BKXausnRk+
         cBiSFCJ8giUiLxAIa49C6Oq/qSpeGkDcfxu1UR+WBzJNB6H0VrzKWOoYYp23yYJ/zG4l
         jNcHQ9LEj3lsRFnee3CIDa1fVW/lNtZi2uscScbiiVc7YuMLP/kQUuI6sNlH0NtHm2n9
         SyWAiHdIJxrmiQH3Ah7BImRFa7W1PSevo5kCSBwOfsLn3gHe2jgUISC3nudQBlILdKJY
         0v9lNBL9wgGo5UmCv7BOm2Dxev70vRHMEOIGZ2A41KLMAJWI/Vvapuz04EdXc66hQsis
         /PYQ==
In-Reply-To: <20190525163742.2616471-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Kernel Team <kernel-team@fb.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Yonghong Song <yhs@fb.com>, LKML <linux-kernel@vger.kernel.org>

On Sat, May 25, 2019 at 9:37 AM Roman Gushchin <guro@fb.com> wrote:
>
> This patchset implements a cgroup bpf auto-detachment functionality:
> bpf programs are detached as soon as possible after removal of the
> cgroup, without waiting for the release of all associated resources.
>
> Patches 2 and 3 are required to implement a corresponding kselftest
> in patch 4.
>
> v5:
>   1) rebase
>
> v4:
>   1) release cgroup bpf data using a workqueue
>   2) add test_cgroup_attach to .gitignore
>
> v3:
>   1) some minor changes and typo fixes
>
> v2:
>   1) removed a bogus check in patch 4
>   2) moved buf[len] = 0 in patch 2

Applied. Thanks!
