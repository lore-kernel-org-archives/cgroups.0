From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC 0/5] kernel: Introduce CPU Namespace
Date: Thu, 21 Oct 2021 12:15:22 -0500
Message-ID: <87tuha7105.fsf@disp2133>
References: <20211009151243.8825-1-psampat@linux.ibm.com>
        <20211011101124.d5mm7skqfhe5g35h@wittgenstein>
        <a0f9ed06-1e5d-d3d0-21a5-710c8e27749c@linux.ibm.com>
        <YWirxCjschoRJQ14@slm.duckdns.org>
        <b5f8505c-38d5-af6f-0de7-4f9df7ae9b9b@linux.ibm.com>
        <YW2g73Lwmrhjg/sv@slm.duckdns.org>
        <77854748-081f-46c7-df51-357ca78b83b3@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <77854748-081f-46c7-df51-357ca78b83b3-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org> (Pratik
        Sampat's message of "Wed, 20 Oct 2021 16:14:25 +0530")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pratik Sampat <psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pratik.r.sampat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Alexey Gladkov <legion-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Pratik Sampat <psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org> writes:

> On 18/10/21 9:59 pm, Tejun Heo wrote:
>> (cc'ing Johannes for memory sizing part)
>>
>> For memory, it's even trickier because in a lot of cases it's impossible to
>> tell how much memory is actually available without trying to use them as
>> active workingset can only be learned by trying to reclaim memory.
>
> Restrictions for memory are even more complicated to model as you have
> pointed out as well.

For memory sizing we currently have MemAvailable in /proc/meminfo which
makes a global guess at that.

We still need roughly that same approximation from an applications
perspective that takes cgroups into account.

There was another conversation not too long ago and it was tenatively
agreed that it could make sense to provide such a number.  However it
was very much requested that an application that would actually use
that number be found so it would be possible to tell what makes a
difference in practice rather than what makes a difference in theory.

Eric



