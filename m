From: Qiang Gao <gaoqiangscut@gmail.com>
Subject: Re: process hangs on do_exit when oom happens
Date: Wed, 24 Oct 2012 11:44:17 +0800
Message-ID: <CAKWKT+ZahFTnPRJ4FCebxfcrcYEBf+PL9Wa_Foygep_gFst4_g@mail.gmail.com>
References: <op.wmbi5kbrn27o5l@gaoqiang-d1.corp.qihoo.net>
	<20121019160425.GA10175@dhcp22.suse.cz>
	<CAKWKT+ZRMHzgCLJ1quGnw-_T1b9OboYKnQdRc2_Z=rdU_PFVtw@mail.gmail.com>
	<CAKTCnzkMQQXRdx=ikydsD9Pm3LuRgf45_=m7ozuFmSZyxazXyA@mail.gmail.com>
	<CAKWKT+bYOf0cEDuiibf6eV2raMxe481y-D+nrBgPWR3R+53zvg@mail.gmail.com>
	<20121023095028.GD15397@dhcp22.suse.cz>
	<CAKWKT+b2s4E7Nne5d0UJwfLGiCXqAUgrCzuuZi6ZPdjszVSmWg@mail.gmail.com>
	<20121023101500.GE15397@dhcp22.suse.cz>
	<CAKTCnzkiabWK8tAORkhg6oW11VvXS-YqBwDzED_3=J1buhaQnQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=dCKLSLyaBlYysG8E3+TFa20VTke2LIpj3jRauGb1FHg=;
        b=yGiR48gnoVHS8tTBTnu1EaIVvvP8An3F19/WQeY09OqpZDxAwAl7neal69EkYVRi+g
         bpCFILcOUm3YmLILzh7JHqFAYC0XUpg3WFoEOSoSWo5DrPoGCAVcA4+5Hq+U3Tzvm6og
         TsQ+lpoTPHr75WEOjPA3DhSZ9uUIsDZ1g3MrElWuimtQGaj09anyo4EQKDiJoOb1vOSX
         rbJfyvmf0h/ksoCZXvr+uCZDOqv3X9E3s/aDUKTA+RLnzchYD5Ms+vjOCHPp0CCJLKM4
         vsYGLegGMNB8uyWApdwgQ89eU1MaqGBXZ6em37wbLWVdLxWFjT4WBuR/Sikwx2nP2Rj4
         w1TA==
In-Reply-To: <CAKTCnzkiabWK8tAORkhg6oW11VvXS-YqBwDzED_3=J1buhaQnQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Balbir Singh <bsingharora@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, linux-mm@kvack.org

On Wed, Oct 24, 2012 at 1:43 AM, Balbir Singh <bsingharora@gmail.com> wrote:
> On Tue, Oct 23, 2012 at 3:45 PM, Michal Hocko <mhocko@suse.cz> wrote:
>> On Tue 23-10-12 18:10:33, Qiang Gao wrote:
>>> On Tue, Oct 23, 2012 at 5:50 PM, Michal Hocko <mhocko@suse.cz> wrote:
>>> > On Tue 23-10-12 15:18:48, Qiang Gao wrote:
>>> >> This process was moved to RT-priority queue when global oom-killer
>>> >> happened to boost the recovery of the system..
>>> >
>>> > Who did that? oom killer doesn't boost the priority (scheduling class)
>>> > AFAIK.
>>> >
>>> >> but it wasn't get properily dealt with. I still have no idea why where
>>> >> the problem is ..
>>> >
>>> > Well your configuration says that there is no runtime reserved for the
>>> > group.
>>> > Please refer to Documentation/scheduler/sched-rt-group.txt for more
>>> > information.
>>> >
>> [...]
>>> maybe this is not a upstream-kernel bug. the centos/redhat kernel
>>> would boost the process to RT prio when the process was selected
>>> by oom-killer.
>>
>> This still looks like your cpu controller is misconfigured. Even if the
>> task is promoted to be realtime.
>
>
> Precisely! You need to have rt bandwidth enabled for RT tasks to run,
> as a workaround please give the groups some RT bandwidth and then work
> out the migration to RT and what should be the defaults on the distro.
>
> Balbir


see https://patchwork.kernel.org/patch/719411/

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
