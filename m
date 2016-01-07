From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv1 3/6] rdmacg: implements rdma cgroup
Date: Fri, 8 Jan 2016 01:55:09 +0530
Message-ID: <CAG53R5Vg9jULp9EU23yd+iUqMDyTMNmUycD8ygX_j98O=JUDmA@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<1452020286-9508-4-git-send-email-pandit.parav@gmail.com>
	<20160105220128.GJ5995@mtj.duckdns.org>
	<CAG53R5UjsDa+JK_afrQ5pMpiDPrc+a+yCOOH3X105pTmU_a53A@mail.gmail.com>
	<20160107152936.GE29797@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=550n0/cl7jZ5CA0M7Tps71/i02KwQggmLFlsnU8SK9U=;
        b=mgnN2fBBU45yJtMJk3vZEEsWSyusNeYalDJPSYoUDHi/RmkQOPXjgEvxL2VGOFGhJc
         9BHRKybWNhOju5VLITnz8B6uDwyGJ40ooDHQkrnZKvr81m84WiJ8doa0va5zYu8NLIBD
         rwItXEW4NGdn/QXo7yePznExx0BK0eD813Rq3dJrwUT18VtURhGoRuplp4NWoRTXGyLL
         FbOw9XKRQ226YcxsXZi63MoHE2FLbAAINXKs1F4nhRWoPiNWUuLjvL15ezyyQ8npaQS5
         FnNf88IbbuEU1XJRrsVEJyGj+W7JqyxzQctJEd1OsNgvGx1fLkFjedpXn1/QzvWG+3hl
         PTFA==
In-Reply-To: <20160107152936.GE29797@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Thu, Jan 7, 2016 at 8:59 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Thu, Jan 07, 2016 at 05:03:07AM +0530, Parav Pandit wrote:
>> Rdma resource can be allocated by parent process, used and freed by
>> child process.
>> Child process could belong to different rdma cgroup.
>> Parent process might have been terminated after creation of rdma
>> cgroup. (Followed by cgroup might have been deleted too).
>> Its discussed in https://lkml.org/lkml/2015/11/2/307
>>
>> In nutshell, there is process that clearly owns the rdma resource.
>> So to keep the design simple, rdma resource is owned by the creator
>> process and cgroup without modifying the task_struct.
>
> So, a resource created by a task in a cgroup staying in the cgroup
> when the task gets migrated is fine; however, a resource being
> allocated in a previous cgroup of the task isn't fine.  Once
> allocated, the resource themselves should be associated with the
> cgroup so that they can be freed from the ones they're allocated from.
>
I probably didn't explain it well in previous email. Let me try again
and see if it make sense.
Whenever resource is allocated, it belongs to a given rdma cgroup.
Whenever its freed, its freed from same rdma cgroup.
(even if the original allocating process is terminated or the original
cgroup is offline now).

Every time a new resource is allocated, its current rdma cgroup is
being considered for allocation.

IB stack keeps the resource ownership with the pid (tgid) structure
and holds reference count to it, so that even if original process is
terminated, its pid structure keeps hovering around until last
resource is freed.

Above functionality is achieved, by maintaining the map this tgid and
associated original cgroup at try_charge(), uncharge() time.

In alternate method,
Its simple to store the pointer of rdma_cgroup structure in the IB
resource structure and hold on reference count to rdma_cgroup.
so that when its freed, uncharge_resource can accept rdma_cgroup
structure pointer.
This method will eliminate current pid map infrastructure all together
and achieve same functionality as described above.

try_charge() would return pointer to rdma_cg or NULL based on
successful charge, or fail respectively.
uncharge() will have rdma_cg as input argument.
Are you ok with that approach?

> If I'm understanding it correctly, the code is bending basic rules
> around how resource and task cgroup membership is tracked, you really
> can't do that.
>
>> > I'm pretty sure you can get away with an fixed length array of
>> > counters.  Please keep it simple.  It's a simple hard limit enforcer.
>> > There's no need to create a massive dynamic infrastrucure.
>>
>> Every resource pool for verbs resource is fixed length array. Length
>> of the array is defined by the IB stack modules.
>> This array is per cgroup, per device.
>> Its per device, because we agreed that we want to address requirement
>> of controlling/configuring them on per device basis.
>> Devices appear and disappear. Therefore they are allocated dynamically.
>> Otherwise this array could be static in cgroup structure.
>
> Please see the previous response.
>
> Thanks.
>
> --
> tejun
