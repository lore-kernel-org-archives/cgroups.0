From: Y Song <ys114321@gmail.com>
Subject: Re: [PATCH] [RFC] bpf: tracing: new helper bpf_get_current_cgroup_ino
Date: Tue, 22 May 2018 21:31:04 -0700
Message-ID: <CAH3MdRVwmKd84ePvNX+NuAj3TfA_28BObEmzBqGXv=P5_A=8fQ@mail.gmail.com>
References: <20180513173318.21680-1-alban@kinvolk.io> <20180521162609.lpdrnozowmzdn57m@ast-mbp.dhcp.thefacebook.com>
 <CAH3MdRWgruVq+3r+2pHTah-c2zTO03vPkepjWDZ0_KrYcroy9A@mail.gmail.com>
 <CAH3MdRVdfw52atavT3KL8MpPw7zDM_hR6aUcqDP1PogLn_sH+w@mail.gmail.com> <20180523033550.z3tqo4lhd3zrmtdu@ast-mbp>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=zlyWijlJVt6Fg6xuMqlSmGHuiPWCPvfN9P6W/vQHEXA=;
        b=U5rLdRQ8j9cVPBsytVUEZx8/8rIS5jgA8Y9tUfMK7bhRD+XV60w1AUI6s+YbK2xWRh
         P+KZtzxAj9YGp3EEGb1IV9hjKEqtY7+YZqovasQkh6qolhc4n2Ovp/X6iiZukUlhiefE
         R02MzBSMlH4+GIUjBRhcdktqab6zjSgqbZvQCGOFVDYxILlKavu2BLLC38oawDnqpVsY
         hEs0DZPOvIOk0rhodAQFkIPlsVbxvgkUHZ+N95gdJ2rJx5wuTXHy7W/THeloq0yFZMpY
         7a/ZkdMCwlR7+3O9Twh2fkHGMAmHGoVpfaaWAKtb3kVHK26JfhpIVBEcDmxToDa/cno0
         M+oA==
In-Reply-To: <20180523033550.z3tqo4lhd3zrmtdu@ast-mbp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Alban Crequy <alban.crequy@gmail.com>, netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, Alban Crequy <alban@kinvolk.io>, tj@kernel.org

On Tue, May 22, 2018 at 8:35 PM, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Tue, May 22, 2018 at 08:33:24PM -0700, Y Song wrote:
>> +       struct cgroup *cgrp = task_dfl_cgroup(current);
>> +       if (!cgrp)
>> +               return -EINVAL;
>
> why this check is needed?

No reason :-) Originally I am concerned whether it is possible cgrp
could be NULL.
By looking at the code, it SEEMS to me that it could not be NULL, but I am not
100% sure (as I am not a cgroup expert). Since you are asking,
probably means it cannot be NULL, so will remove it in formal upstream patch.
