From: Florian Schmidt <flosch@nutanix.com>
Subject: Re: [RFC] memcg v1: provide read access to memory.pressure_level
Date: Mon, 27 Mar 2023 14:59:37 +0100
Message-ID: <6f4420d0-2f86-7294-01e1-6806ef7e4686@nutanix.com>
References: <20230322142525.162469-1-flosch@nutanix.com>
 <20230324150350.fu7itbqqvtjmyf3s@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=Y8oMA2Kh90fJuaqHhLVsPbnGur2i+yIZVcZrAVQRP/A=;
 b=W4WeRm0IU4n37kzCd8POz3yWGzxUg7seVsLUW3V5IGq/j4nmbMPx1FZprJabu88hWENk
 v8vCB9gQFVJgqqhijHeu8auEFybDh8OkTnmnkOmMhFhbv5Nir5aXw9Nlo6BmyxneZ2Io
 NHVFh9tfCrOZUd3QF0zyvFcjDFg/1mIkOf5w+2S9VcWy9CbIHcTX5za9IswzbgGJw/Do
 8+Agdd9CokYXwCXHOdOFGKMdWA8euh7pZ1oypgvKJ+ABMP2rEc7zWp8OHaUMy936wp7S
 Qbhh6SmvktOMkrc2uWuOLxaSa/DIMZx4eChDY5KAxz1WUr5fZDJ6bOgW9VXfGPv/Bitp nw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8oMA2Kh90fJuaqHhLVsPbnGur2i+yIZVcZrAVQRP/A=;
 b=ejONGk/JR1bdBpcjQN9SClty6+JTvbF27IwWTmDZQ33r1ES1kH0jMg5fCPGrmBaaq412Yiiul1Tb7KK2YXWOI6YxVrX+F2oo5TIu6ZLrjB7PmbMG27zIWjLGUlPfErR+8JLdqP7LGmLRf/x0EWdGtFjOz57R7EFDD0tNDruk73cyx98BSkBGu1viNjw7j1Qc6ruUo0ik4VNuP2mLYE/kFw2jp9ruOuMnVXpzpbsTfuppSFt/y2dIcqUZtTe6xB8z8IzabqnSw96JxAGS8TQwIjRFlSmxyiCWn0oJ6e1Oce29VB4I3bshc5XIY8VlXhhQAf+FIcddss3/upr61MnmtA==
Content-Language: en-US
In-Reply-To: <20230324150350.fu7itbqqvtjmyf3s@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Hi Michal,

On 24/03/2023 15:03, Michal Koutn=C3=BD wrote:
> On Wed, Mar 22, 2023 at 02:25:25PM +0000, Florian Schmidt <flosch@nutanix=
.com> wrote:
>> cgroups v1 has a unique way of setting up memory pressure notifications:
> ...
>> There are several ways around this issue, but adding a dummy read
>> handler seems like the least invasive to me. I'd be interested to hear:
>> (a) do you think there is a less invasive way? Alternatively, we could
>>      add a flag in cftype in include/linux/cgroup-defs.h, but that seems
>>      more invasive for what is a legacy interface.
>=20
> You can (as privileged user) modify file perms in userspace first (e.g.
> chmod o+r memory.pressure_level) and then it can used by non-privileged
> users. (Or do LSM prevent you from that too?)

That's true, we can work around this in userspace (though it means you=20
need to give the process additional permissions, to change file=20
permissions on top of just reading and writing).

Though considering that the memcg_write_event_control() explicitly=20
checks whether the caller has read permissions on pressure_level, it=20
felt sensible to me that the file would be created with read permissions=20
in the first place, just like all the other files are created with=20
permissions that are suitable for their immediate use without having to=20
manually change permissions. The current implementation feels=20
inconsistent in that way.


>> (b) would you be interested to take this patch, or is it too niche a fix
>>      for a legacy subsystem?
>=20
> I'd rather not extend this "unique way" with additionally unique dummy
> helpers.

I understand that this is all code that has no modern user any more,=20
which is why I tried to keep the fix as self-contained as possible.
Another option would be to have a special handler in cgroup_file_mode(),=20
but that feels a lot klunkier to me, and leaks a v1-specific behaviour=20
into the shared cgroup code.


Cheers,
Florian
