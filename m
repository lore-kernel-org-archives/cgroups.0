From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 11 Nov 2013 17:11:04 +0100
Message-ID: <CA+SBX_PiRoL7HU-C_wXHjHYduYrbTjO3i6_OoHOJ_Mq+sMZStg@mail.gmail.com>
References: <20131031130647.0ff6f2c7@gandalf.local.home>
	<alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
	<20131031192732.2dbb14b3@gandalf.local.home>
	<CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
	<5277932C.40400@huawei.com>
	<CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
	<5278B3F1.9040502@huawei.com>
	<20131107235301.GB1092@cmpxchg.org>
	<20131108001437.GC1092@cmpxchg.org>
	<CA+SBX_P6wzmb0k0qM1m06C_1024ZTfYZOs0axLBBJm46X+osqA@mail.gmail.com>
	<20131111153943.GA22384@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=OAJt/il23HLB+jJk9EYc0Wt/2eU61KG070MnfEzYyEQ=;
        b=ys7ds/N3ZnEaL0S+tru+Qn549ITZmWiuhx6cv3pQHUatVf5Ye2EKFfW7ccE7senxkd
         VAobw4izceLnZpyYm5Duf2yBSKmkWTBMC9ve6mOaa79DX2AXhC0gPxybFxjWzZgE9NE8
         yVB96miGxXP+mx3euZvodjBKAgbMj+wyu//lCeVlzTmYm4r5vuO2YPJ0fwfVHLATZhEu
         MH4JPVfmu09dtATkQEjb4fLocfC/SHxAMOCVyiOIr0kFVf3Px+QdvS1z9ur9zPAvG41F
         OgUstQLx3rz6xjGq+ZVPCvV2c2ej3aNApsis8j8OlorrTLDoxYC4U5ilFuDSQMuXLz6z
         aZ6A==
In-Reply-To: <20131111153943.GA22384-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>
> Out of curiosity, do you have memcg swap accounting enabled? Or do you
> use kmem accounting? How does your cgroup tree look like?

I have compiled my kernel with CONFIG_MEMCG_SWAP,
CONFIG_MEMCG_SWAP_ENABLED, CONFIG_MEMCG_KMEM and CONFIG_CGROUP_HUGETLB
options, although our machines have no active swap space at the
moment.
The cgroup tree is maintained by the SLURM cluster queueing system and
looks like this:

/sys/fs/cgroup/memory
`-- slurm
    `-- uid_181994
        |-- job_56870
        |   |-- step_0
        |   `-- step_4294967294
        |-- job_56871
        |   |-- step_0
        |   `-- step_4294967294
        |-- job_56872
        |   |-- step_0
        |   `-- step_4294967294
        |-- job_56873
        |   |-- step_0
        |   `-- step_4294967294
        |-- job_56874
        |   |-- step_0
        |   `-- step_4294967294
        |-- job_56875
        |   |-- step_0
        |   `-- step_4294967294
        |-- job_56876
        |   |-- step_0
        |   `-- step_4294967294
        |-- job_56877
        |   |-- step_0
        |   `-- step_4294967294
        |-- job_56878
        |   |-- step_0
        |   `-- step_4294967294
        |-- job_56879
        |   |-- step_0
        |   `-- step_4294967294
        `-- job_56885
            |-- step_0
            `-- step_4294967294

memory.use_hierarchy support is enabled and memory is limited from the
job directory. I have mounted the cgroup to /var/slurm/cgroup/memory
in addition to the normal directory at /sys/fs/cgroup/memory. The
slurm release_agent script is the following: (the script is called
release_memory, so the subsystem variable is "memory")

#!/bin/bash
#
# Generic release agent for SLURM cgroup usage
#
# Manage cgroup hierarchy like :
#
# /sys/fs/cgroup/subsystem/uid_%/job_%/step_%/task_%
#
# Automatically sync uid_% cgroups to be coherent
# with remaining job childs when one of them is removed
# by a call to this release agent.
# The synchronisation is made in a flock on the root cgroup
# to ensure coherency of the cgroups contents.
#

progname=$(basename $0)
subsystem=${progname##*_}

get_mount_dir()
{
    local lssubsys=$(type -p lssubsys)
    if [[ $lssubsys ]]; then
        $lssubsys -m $subsystem | awk '{print $2}'
    else
        echo "/sys/fs/cgroup/$subsystem"
    fi
}

mountdir=$(get_mount_dir)

if [[ $# -eq 0 ]]
then
    echo "Usage: $(basename $0) [sync] cgroup"
    exit 1
fi

# build orphan cg path
if [[ $# -eq 1 ]]
then
    rmcg=${mountdir}$1
else
    rmcg=${mountdir}$2
fi
slurmcg=${rmcg%/uid_*}
if [[ ${slurmcg} == ${rmcg} ]]
then
    # not a slurm job pattern, perhaps the slurmcg, just remove
    # the dir with a lock and exit
    flock -x ${mountdir} -c "rmdir ${rmcg}"
    exit $?
fi
orphancg=${slurmcg}/orphan

# make sure orphan cgroup is existing
if [[ ! -d ${orphancg} ]]
then
    mkdir ${orphancg}
    case ${subsystem} in
        cpuset)
            cat ${mountdir}/cpuset.cpus > ${orphancg}/cpuset.cpus
            cat ${mountdir}/cpuset.mems > ${orphancg}/cpuset.mems
            ;;
        *)
            ;;
    esac
fi

# kernel call
if [[ $# -eq 1 ]]
then

    rmcg=${mountdir}$@

    # try to extract the uid cgroup from the input one
    # ( extract /uid_% from /uid%/job_*...)
    uidcg=${rmcg%/job_*}
    if [[ ${uidcg} == ${rmcg} ]]
    then
        # not a slurm job pattern, perhaps the uidcg, just remove
        # the dir with a lock and exit
        flock -x ${mountdir} -c "rmdir ${rmcg}"
        exit $?
    fi

    if [[ -d ${mountdir} ]]
    then
        flock -x ${mountdir} -c "$0 sync $@"
    fi

    exit $?

# sync subcall (called using flock by the kernel hook to be sure
# that no one is manipulating the hierarchy, i.e. PAM, SLURM, ...)
elif [[ $# -eq 2 ]] && [[ $1 == "sync" ]]
then

    shift
    rmcg=${mountdir}$@
    uidcg=${rmcg%/job_*}

    # remove this cgroup
    if [[ -d ${rmcg} ]]
    then
        case ${subsystem} in
            memory)
                # help to correctly remove lazy cleaning memcg
                # but still not perfect
                sleep 1
                ;;
            *)
                ;;
        esac
        rmdir ${rmcg}
    fi
    if [[ ${uidcg} == ${rmcg} ]]
    then
        ## not a slurm job pattern exit now do not sync
        exit 0
    fi

    # sync the user cgroup based on targeted subsystem
    # and the remaining job
    if [[ -d ${uidcg} ]]
    then
        case ${subsystem} in
            cpuset)
                cpus=$(cat ${uidcg}/job_*/cpuset.cpus 2>/dev/null)
                if [[ -n ${cpus} ]]
                then
                    cpus=$(scontrol show hostnames $(echo ${cpus} | tr ' ' ','))
                    cpus=$(echo ${cpus} | tr ' ' ',')
                    echo ${cpus} > ${uidcg}/cpuset.cpus
                else
                    # first move the remaining processes to
                    # a cgroup reserved for orphaned processes
                    for t in $(cat ${uidcg}/tasks)
                    do
                        echo $t > ${orphancg}/tasks
                    done
                    # then remove the remaining cpus from the cgroup
                    echo "" > ${uidcg}/cpuset.cpus
                fi
                ;;
            *)
                ;;
        esac
    fi

# error
else
    echo "Usage: $(basename $0) [sync] cgroup"
    exit 1
fi

exit 0
