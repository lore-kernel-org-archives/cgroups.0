From: Qiang Gao <gaoqiangscut@gmail.com>
Subject: Re: process hangs on do_exit when oom happens
Date: Tue, 23 Oct 2012 17:08:40 +0800
Message-ID: <CAKWKT+ZG-Rw5spLUdn74H3QQ1RGrax2B4X_ksZB-OCHY5WXC6w@mail.gmail.com>
References: <op.wmbi5kbrn27o5l@gaoqiang-d1.corp.qihoo.net>
	<20121019160425.GA10175@dhcp22.suse.cz>
	<CAKWKT+ZRMHzgCLJ1quGnw-_T1b9OboYKnQdRc2_Z=rdU_PFVtw@mail.gmail.com>
	<20121023083556.GB15397@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-mmc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=MtmT7/Oyrka3ErznowLfkSTsyys9Fjm+mhD27qqqcRs=;
        b=r9Se4sJiN3LPnUI7tNPhgz3DrHE/8GoBLsgiPmjY8HwGrKYhw5Q7jSBPiXX7Uzswv+
         L1W4HiKc5eJ70qP8B4qF5C+x44ZRHn3jk5HJ2G3jk5FwHR0jWRiXHeDaAIFEn+1A8mha
         C2xsc42w/V6S7mJFr6VnWRwENwKuvoI3JJnpoARYGChzMKXOXLvJUFqRFkSjl3ReMulp
         mVVNC6qcmP9IXhWo35SVjbu4wqfNpCFrE0adtCsESTpFFuK0kdLL1qVWP7bK86QE8Ha9
         yP3Hi/CYn//lK/Ngs8LhVTkFGLptWbUNJlxpfhgDqYXAkeNTKxjI41va618+8LWi820N
         9YHg==
In-Reply-To: <20121023083556.GB15397@dhcp22.suse.cz>
Sender: linux-mmc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, linux-mm@kvack.org, bsingharora@gmail.com

this is just an example to show how to reproduce. actually,the first time I saw
this situation was on a machine with 288G RAM with many tasks running and
we limit 30G for each.  but finanlly, no one exceeds this limit the the system
oom.


On Tue, Oct 23, 2012 at 4:35 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Tue 23-10-12 11:35:52, Qiang Gao wrote:
>> I'm sure this is a global-oom,not cgroup-oom. [the dmesg output in the end]
>
> Yes this is the global oom killer because:
>> cglimit -M 700M ./tt
>> then after global-oom,the process hangs..
>
>> 179184 pages RAM
>
> So you have ~700M of RAM so the memcg limit is basically pointless as it
> cannot be reached...
> --
> Michal Hocko
> SUSE Labs
